Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673BFC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3B76B008C; Thu, 17 Sep 2026 05:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585076B0092; Thu, 17 Sep 2026 05:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1496B0093; Thu, 17 Sep 2026 05:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242D06B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:56:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02F35802C1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:56:25 +0000 (UTC)
X-FDA: 85222799172.18.3DE1A23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5119A4000D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:56:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJtCXNWO;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638984;
	b=hMvYB24WMD8tK71JZK3M9POspbiNxRMgmiL68lTpbTHxuBV16uvjiF5/JRO4G2o4q9Fkpx
	0rYb5nnXvmyVALRl867H+BVaED+a5bHO6c2tbLqqyP7P16z6DhP/oow4SGbPgXQIPmLewt
	K4MGEkszbRxw884WekIG3IQJqUbxaTQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJtCXNWO;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7oxuwwWIpTFWySqmvsqUWw79LWpxoi0hva+IYJpzMw=;
	b=dhQQKdu28hMUDkGY0YAcysthkGg8VMAgpxONxwQtwtsVWzHm+OLL+poYltOZmPcZpwfs0d
	QAZP7Ava/781tmDePMEzh7r3HXLSFkxKJjgYkqefqQoIRau5v/1GvINdPtY+bG1Tg3fiqM
	14gPZKEY6IV4Rtfd+vbzsQFYHcrDnTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 115B1600D4;
	Thu, 17 Sep 2026 09:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F861F00898;
	Thu, 17 Sep 2026 09:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638982;
	bh=/7oxuwwWIpTFWySqmvsqUWw79LWpxoi0hva+IYJpzMw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=cJtCXNWOgFCdWwmJZwaRr8nKw9i9xNwe77+2TgiyOj1f9fj8jEhhhUS1CxDrff+Yn
	 hKuSCEG+VHKLHGyjyYcOtPooNCmyAy3ATqGnN/cwlRav5rLk8lZdRVBJzO75/J3d+R
	 cu5BNje8po9VeH1g3XE8YqwLef+e9H+y31Y4jGBLswkwF8r/NB+3wgKk3CP/phuHyl
	 y1ovXgTZb8+quCTecyy/gET02eGU8sXrl6njdZmXAw5nM2+QKQ6w5yPVyqvLhACaOf
	 VzakmCdZf29IIwYfpM+emzI4UpA5nSIG/pF3BDLWFBicOTnaBinLnBdQnePtRYwUyo
	 0TUSlvQWGgSlw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/5 v2] fs: Deferred inode reclaim
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Christian Brauner <brauner@kernel.org>, 
 Christoph Hellwig <hch@infradead.org>, 
 Mikhail Rudenko <xyzzy@yandex-team.ru>
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
References: <20260911081309.14137-1-jack@suse.cz>
Date: Thu, 17 Sep 2026 11:56:17 +0200
Message-Id: <20260917-entweder-limitieren-kiefer-f033614058bd@brauner>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2504; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VCZHxc330ypE/b3a5kfGoh/S/n6AlhOTYGFl6/P9O/c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3uncfur99qXGp1aLb566cc00kWUsHzvm+UjdPPVpy
 tRnmmrZfzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmIjaT4b+Hmsbi4rui2sz+
 K+UVr1kskfd6JRA710IpcjdnwydRlbUM/zSX3D/IzdnWeH3NO4UV7CZcCzw2tDtzldv9vVV0f0W
 cAwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5119A4000D
X-Rspam-User: 
X-Stat-Signature: ba8wjopapdx17z17i35gduayag36scse
X-HE-Tag: 1789638984-958907
X-HE-Meta: U2FsdGVkX196SCprj5qdSnsLMGOymc1+7iyv9FchS3KG5K0V0+jPsFta/Oh8Hz1NM3OkFsmRxVbstL+WdAmp1K8hnvIMYDxRaPdmvDLTXl54sjdJKfKBLVy8XLl2cuuNbiue/GWiJcMPEMqlKBx4hx5YbVFxcRcWZva78UEWUXIacLFqD/yThSed6fhUAmFZ4xBbjUfItVGr/5FS9yw73xTw+2fdCDtFR3je39J1q7kXb1ovJzuCyIgv3hkojF/nSukQB92kHq9IxoOgC0zdWuTjPeFi92+iBTS2cJf0B/mGtuE1bg3hPkavOtpLymMtOdoB2hU45tsLwk8dpWMxY2bY4Q1o+m96DwkovuC36Gk2FS4rcH0JMDx4hoF1SIB1hwgCJKrm6djWWpYdzbIylUJl3rE8ZTeTqHpmCS1D7OuwGo8HONABz11qbbH6+bwwsscu3pTX56YuI6G6Z0fC+qSBtYUSb3xP+UK30ZGQKaJRa3SfbvKy7buapfS4KVXvHN/VICIyr06IfsCLOpCQqfIYowcGWBqTswfCPhx6U2DKd7YqUq0muvwINAA8yPI6HgSl6Pors7B32Z5B6rXzNrYQqpQvJ/Iz+FXMXEAZbNcHJe+4h7gpxbxP5n01AZUS32ZWYA0SMsRFrQFKBkzPimwBoVB81rA/HCir6h5owt7+09Khxu/DlzMdlD1jtClgeAIXpZhMrvXZBSbwmaTAdpVSvQwICHUJXsXV4v3Sk1p4ukEzlBjrQx5sQYWAyiCQ/Wh00BFxGA1QKi4wAoyiACuUdCtkkCyMvWWDmcRXUg7KEIPOXKv5IqnMcwF4IHr3xQoyOANKPMHVddpIG2gkJnx6iSyh3tmo0RKePIl+AJLAnUnyYJSkc1XrKvupO21YWpaVpxO2FptCb9AKChDskpEH4YIwCe7Me/+2lB/RK5vvzt2sKaorjnCIEMhoz4ybNtj+ESyNEikKkKZ78Wv
 RWwD7GZj
 PfWf4c7rnsK28A6K6K3Dl6B26KEWXQSiiL0SJLoCYaiSJGRlkDQwfCpctb3vKIHl01L9jO4c6F2NCV8efyp6UTRvv3khKpuWCmrMF2VUTNbGSODpu7uICappuQQ+Jn4NFf3Ikvv8jAFMPTMjkT5rDBrtJ7rH8VO4u3jIFKa3/sZVsSR35bbIBwYbhTZYMwvNkhp2P7mjA7KLF5hBYKYMEVrHaPan1ZGJjkcMcNJ24eRAkoq6aU5NildRwdHpWGKYQAOozo3MQ9yAJxHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello,
> 
> after a long pause here is a second revision of my patches implementing
> deferred inode reclaim to deal with MM warnings due to GFP_NOFAIL allocations
> from reclaim paths. This happens because to reclaim some inodes, filesystems
> have to do IO including complex operations using journalling and forward
> progress of these depends on successful memory allocations (which is impossible
> to guarantee from reclaim context).
> 
> This time I have fully tested the patch set. In particular it survives full
> fstests run on ext4 both as is as well as when marking all loaded ext4 inodes
> for deferred reclaim to stress the deferred reclaim paths. I have also tested
> (when marking all inodes for deferred reclaim) the patches by creating a memcg
> with 128m memory limit and then scanning from 10 processes 600k inodes in total
> which heavily exercises deferred inode reclaim paths. This also verified
> efficiency of throttling of marking of inodes for deferred reclaim. Basically
> we cannot guarantee any particular limit on the number of inodes queued for
> deferred reclaim as that is bound only by their number in memory and memory
> pressure. But as the number of queued inodes grows, the tasks creating them
> get slowed down so eventually some equilibrium is hit. In my VM this was
> at ~10k inodes (only slightly above the 8k limit when throttling kicks in)
> but this all very much depends on the reclaim pressure, speed of deferred
> reclaim etc. so I don't think this is some representative number.
> 
> The first patch is a pure fix for a problem I've hit when running fstests.  The
> second patch deals with lazy timestamp updates which I've decided to handle
> better directly inside the writeback infrastructure instead of deferring
> reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
> deferred inode reclaim is there mostly as a demonstration. Other filesystems
> need to determine which inodes need deferred reclaim and mark them as such
> which generally requires good internal knowledge of the filesystem. I'm hoping
> that once the infrastructure is there, fs developers prompted by MM warnings
> will start using it :). I know for a fact that besides ext4 e.g. btrfs is
> hitting MM warnings in inode reclaim as well.

This all looks worthwhile to me!
Note that Sashiko is complaining about long-term stalls introduced by
this patchset. If this is intended or bs then please let us know.

-- 


