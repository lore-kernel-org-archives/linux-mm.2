Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4E6C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6216B008A; Tue,  1 Sep 2026 01:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077306B009E; Tue,  1 Sep 2026 01:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF6A6B00A1; Tue,  1 Sep 2026 01:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9EA6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:56:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 568B1A3EA0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:56:13 +0000 (UTC)
X-FDA: 85164133026.04.3720919
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5035100005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:56:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou7BODbI;
	spf=pass (imf05.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788242171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mnj837MmtIz++Lx3CjViaHZJuFNdZX481goDRHR5Jo=;
	b=NThxo3OEzM9p9IBqbge3ezhRIz8OCXiem437dZ+04tK4ElodxMr/5ZkmxwIdCRgcPsul4U
	x9O0hs+thExdQOD1jvmYC8WeJ5Jk67mNnFrJ2uTkYTTYam6pK3fG8TvMZ9US2Rmh9v7xu5
	8dEPSCj6kj5l/0pSHb0gZjfQD7kcqkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788242171;
	b=zifDN1y0Gk8U8s0ljTctyMpnceEgy1DUFFFk6jBPRaVm2m/6bnBwr6ic+97OISmPhRxtNh
	aUifuV3lYq6NZsrp74afOZ03R0Z1crQYCJNP/RBRe9IHCr0h/lRI5D/5piN2KsyOZQX3Qr
	340fzxcs/vaqHx7iXdDyqMpwudWyAWU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou7BODbI;
	spf=pass (imf05.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC3FB40338;
	Tue,  1 Sep 2026 05:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494581F000E9;
	Tue,  1 Sep 2026 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788242170;
	bh=3Mnj837MmtIz++Lx3CjViaHZJuFNdZX481goDRHR5Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ou7BODbIZicrSpeSM00EfOJQrJABefs9Kuf2EhFYV6gK2dq64CXKdSuL3RyZbLucK
	 TPg17Tyz0+5ncdV6c1HL6WGWK3QRh4+wm6tY9EoV1ldMeb65SaokB3SYllaBh+BMU+
	 k3fxxYQqKpob1eGKNeK6NERFb4+ExYOKE40Jru2B8rYntpuKlNuC0j8YO4qOVeoRfS
	 0Gai2YDP4tJxaz3XlpWyH0B+gdt6KErKtSPMpBpFla9M4/VF7fFDFR9rb7sXCytJmv
	 hvNVEuFK2QwrR66uR+fQsxbPPuwkUO9XsB0pubH/TfXp4lry7WXlo5qdiAM9FijGEM
	 OmAyFu0d6q/4A==
Date: Tue, 1 Sep 2026 13:55:42 +0800
From: Gao Xiang <xiang@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Message-ID: <apZo3lDaDp3hQhRq@XiangdeMacBook-Pro.local>
Mail-Followup-To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-4-willy@infradead.org>
X-Stat-Signature: zto1a7kbb71c64ocyob3e9t7qysbmhd7
X-Rspamd-Queue-Id: A5035100005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788242171-387654
X-HE-Meta: U2FsdGVkX1+wup+tuKE1SvgJecputGQlg4JyQOVECpl1riL/NGgWdSCWXE7WzD3V4Zs8ysYcwyMtOB8rGhhRF+aMQhNAT0USOgi/hBCpsT9BwB+s/pAN7kXI8VOjM0edgtnyN+0lVpQde41+rDyLvSthA0/gwYHNQw6pp7CYF7RJX7l7yOjt/Bn6qvh3hL1BMC084rI66voQiHNIe9GAVuboqJmlp62CpZ2JMiX16O4h9AiX1A/KQuA/Wo+vEZrtjYd08gbHGUznJol+ogMudnBBJjp4HiY2HGZcgLbrPQd8dxC52Ix18bWpLu3/i9qnHzKa/s3eODSRtZuKp5DPvHvXI5hn2/sqZSzurTpvzdw8nqZQAd2TdWtITujQ/UnnPiFZG4cxCb8aXOPm1/MqMBXUqhwyUZhmFW3nfnP3IWRo89jqq9pJLcck4nUd2dWwbdAdxRGY+AeHTzJwt7NOOrfqggtQzXeZnFW3xycAX+D08YYtcoIB37mF/Lem8lsmLWmvJohn8jqXi1secEMbRQM+/dNYswdkY4nLeZxSKW2uST+D4h4mT0b7qtS6k0pukqdBNFyCoZvFG5+eza05/wmH47zu4eC0du2bKionyrF86TK/YLdhjL1JwyOIhJtAIuhKdpKdxql33rbAgPERjWRRGyEsj3ZqNSvs82ymDpTdz4J56/dJPirJVZqGchcGX9mN57x79LhMZhuxzA5YFqhxuk9eQE9Ui6EXqFhZaOVCjmI2UbNL+IyGjRnqvZviu+p4HkOAQ3VnbIIgr1BQkr/CjplYsYG+f9cvDQZVHymJwRej9d0Be+RsYWS5U64lf9w5n/egxlsl+oqcg3G9htZLASHMLl8UB/UFvqvPt7XoOc4RChMnRSlXuXmE/hrfQHZ/+whBHRc5YPne6F4oLZu312FoIRAZJ0iBF59BC/gKjEkRIpxyfnDzbtiEXWhNWd/5qVo+/3EUXlxJz2/
 kpP+1ZnD
 GZkssFaM2c3qmASIJutc4s9iPKiD1YSR1EhOXkxIYa583ugjLj5D6EIEOrw93cJUWfMhm8s2ElMbaUTKVJ4adZjb7XqTOdaCTcalS9hL1tpeAy15LIpGT+YlYfPZXK/MBSj/3kkjVcoFOs0razIn9cP+5DjVkVU4+wg3MyATaqJchvE20AAxMm7TtBGcIAtztLt+qBia+neWGHH6Cn7wh/JhKE2aaS6ooFADtKA9/CDdfkKzsbLpOgjZ3auLGzolK3UHKhVT9hs3C75GnhjZDUJO2JMuLN4ba0bpUo4WA1t1ceY5uW27puLN2cHqvUy3tJULiPa/s3VamXXZFHw/532jeI1xkU0lxDvrSCx5cAxbRFkUM5Ud7KrGZepvF8YI175x5k+Ra7vgCB7xfEtKW4OC94Cyj30WRFrSbWi/dqgwW4O413sYtUgm+gZ0FmgIeAVe+u2515F2qpCYCiMC6+QgrfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 05:18:50AM +0100, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

