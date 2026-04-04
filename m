Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BECE63FF6
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDAC6B0088; Sat,  4 Apr 2026 16:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67D06B0089; Sat,  4 Apr 2026 16:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56516B008A; Sat,  4 Apr 2026 16:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF3806B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:18:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5168C140863
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:18:28 +0000 (UTC)
X-FDA: 84621985896.29.D742075
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2DC9100005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:18:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ek8unC4z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775333906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSpH/h0LjZAC5HGhtYYa0aIBfXgwtDHD86HOxIOfkbo=;
	b=iIsmTAEi7UCf95AudtX9+VY6nZJ82idMuaequE0gQbigOwvvjXpXit37zAXONjmBDOPgV5
	cIsUr0zHMxk9i3n6uL/+slPrtJMHhnA99wMDiNOnLENj7/Kni8mh7COwzDQSPC5qC0fVBy
	Mo0DtfDL24ch+cqxJIb9T5JIvhYEIKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775333906; a=rsa-sha256;
	cv=none;
	b=n6YJtCu4Oy6iVTbN2Oh6iRzjBJJh1SlPStD0Pj1cYsYQdQyfpVw/guG0BQKjZ5gNeJhJaS
	kuOD28mK12r+JSNBOTAcav2r9nUScOko68OOoAJMNv2VTKGbrEsTwf4ViE9rGvH0qTIoJQ
	8x/FXgH9Ji/+T3QULu2GZrJ8BjB6IeY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ek8unC4z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48C6560008;
	Sat,  4 Apr 2026 20:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55CEC19421;
	Sat,  4 Apr 2026 20:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775333906;
	bh=K6O4i08ap+LxKyMLBh3GuSwkcMBslt2u7/g+pm5nHNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek8unC4z3EgITSjggKAHQB7m5LIA5qkhMQrgOAp9HyruoyzSCFZ+cttIS+GHuXphO
	 8s1OiCEVoYyxfMZarOvxWzm5zNhiaCGyg9C8JwFi+nR6MXnf7oPFFnwd4zKwTtcCWO
	 OnMJo0KoKOFts8kyF/zqnLXbq0jBwItQsRCuv+sHkRm7pK7Jrg8bK0Ez48IlMXsCWL
	 4r7VZOtFykyH6Q2OnEsppFPfhHWAIyidvmnqLklxlmt23NTU7UCq3u2bfR3C0YlvDp
	 dpBeBAX9vM1NM9Edc0DKBhQqqUSCbRooqESFb2PFnxu1QTCVIE4wcrIsiOT6i0noMI
	 TdN4SNCJWUstw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat,  4 Apr 2026 13:18:21 -0700
Message-ID: <20260404201822.86511-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404090927.6055-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2DC9100005
X-Stat-Signature: qu8ndqoxyw6n85u4h1b1x6yjahshidhd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775333906-866707
X-HE-Meta: U2FsdGVkX1/GGPgwN9PMkPVsSwQ8+NyKFE0JH53KFiwzFOpevgOEkufq+6N9+UMK6Y0l9K3TzCeWLrTkE/H5TIFMsN/Ht7mMySPsyHwNA1QysD9T6uPvMHG0iH7n9kvWD6GH3hPPxv8hlFmpkE4zlTnyQyLcHq2AwXftaNrqMgfkoaggZCgPuvFIbU5965UvjZjpXCEzNLy/ahECxGM55+Jr3xxp1Wf9/ev/yxeh8r0MviNFXrW4RuLwMxGpd1g+AtXixL2fEyxohS752WqA1jRWy8qHTLtgu+JTRpbBooKTl5jWil0JfvZwyMDEZ+vrHtwhCcMHc7mgv5E9aDMkrK1XS3m60N0du2lsO8npgROe8II+Q9AXD056EHMfI8CJcYTBX4qXKxEkUyV9q4Kc3HrZy2xnylsQc0Dr3WdwkwhkGwf3waF6OifNw+VKVlPyCYU3N3CKGa3/rUgxkgm7ZxXsoFahudVPifjNIIdHrrArAruFFkRyEbwca1XbtdwnDNMq8XDhWCSCTadppefynNBDEk/DK7cRZChbEQyd+Wh35MJzjVb3oXiYYT5xXLjS79YueZRH7XIdMtMWPFcuAtW13DeKnvh++mY1ohDaJ6WgAotJ0UdyPtFA61ZS7xo66sQ3HjnhiFlhe2oqcl8PAwT/zwhERmUsv75fILol45B2dPYR4jLyHIZLbdAjwtMweKRWC1pg3BymhNO2PAiQRZ1WPzOglO0DFl1M8L23feVxzunBJKagAUnbnu9cC4T4LytBvvh/p/6jXkps07xE4Z+LIOIqJDmmv5PPW/9Qo2STgQHJpGR0HgK2AjAM0no2+vT/0IhF/LMnCO081s93ccEJp2QRjyhPjheaOPgM/U+7qDKzbJYFMcqUbp8RuJvJPoGuxN6bkPCUtCluHSRyrITKe1Cqm5BpTxwdiHlpFOG152KqGrOLy2HtAw7QBa25W6ElRlAUDgW8Rn9UJ0M
 eu4P5fu5
 VWoFMEx5dfdjNtxkSMiOBONm5gFwcYj8FqOLEPwW1aTQkKdqVOlomBLMtSvnOKO6pI4E5wLGMnva2V9gG10YJ0ggqskATUwtz7F/iEOZkM11A3GT3QJMfE1Vw2gtz2mMDzyc4+KBHO4RIns2TFZVK9YqIM2jnljWUsuIA1QQ4ZmGG+4ysNjoyz0Jr4NPegIxyDs2bR7vY1GJP+7nHeH9DjmHqWAWMomM+3oMcTu65xocDptGp9iNTcOI0/VRCcYiVymHSbVDSwvd85RQ7CsaifTPSf7AuFExyBlMXDJsg6w+oqm3CAyhR3sQW06LNjCz2oVtdjp9WRjlrXVlhTB1k8/V/6RmqLJ3KfF1zXhiZoOmupnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Apr 2026 17:09:27 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri,  3 Apr 2026 08:55:29 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > I recently learned not everyone is interested [1] in sashiko review.  So when
> > I sharing sashiko review, I now try to drop recipients who are not necessarily
> > interested in the review.  My choices at the moment is the author of the patch,
> > maintainers of the subsystem, and the mailing lists of the subsystem.
> > 
> > So if I was sharing this review, I would dropped stable@ and yanquanmin1@ from
> > the Cc list.
> > 
> > Please consider doing similar when you share sashiko review.
> > 
> > Everyone including myself is learning how to use sashiko well, so it could be
> > confusing.  Sorry about that.  I'm planning to make a guideline for sashiko
> > review usage in DAMON subsystem, and update hkml to embed it, hoping that to
> > help reducing some of the confusion.
> 
> Thank you for the guidance, I will keep this in mind for future Sashiko
> review forwards.

No worry.  I just pushed hkml change for this.  The latest version of hkml will
add the guide to the forwarding mail draft and make the format easier to add
your inline comments together, by default like below:

    $ hkml patch sashiko_dev 20260325013939.18167-1-aethernet65535@gmail.com --for_forwarding

    Adding your opinion together with the sashiko review sharing
    is a recommended practice for reducing traffic.  Will you
    do so?  If so, I will adjust format to be easier for that
    [Y/n]
    # sashiko review suggestions
    #
    # 1. Consider reducing recipients.  Maybe the author,
    #    maintainers, reviewers, and mailing list of the
    #    direct subsystem and parent susystem mailing lists
    #    could be a starting point.
    # 2. Add short summary of your opinion at the beginning.
    #    For example:
    #
    #      sashiko found an issue.  I will respin this patch.
    #      sashiko found no issue.
    #
    # Please don't forget removing this comment block before
    # sending this!

    Forwarding sashiko review in a reply format with my inline
    comments below, for details of my view and doing discussions
    via mails if needed.

    > # review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
    > # start of sashiko.dev inline review
    > commit 60ccea4154b0c58741fae2323454a5a9496b67fa
    > Author: Liew Rui Yan <aethernet65535@gmail.com>
    [...]

> 
> > Anyway, seems sashiko found no blockers for this patch.
> 
> And thank you very much for reviewing the review! :>

I'm happy to help :)


Thanks,
SJ

[...]

