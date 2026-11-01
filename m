Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31409606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WhlDmhe1
Received: by kanga.kvack.org (Postfix)
	id E160A6B00EF; Sun,  1 Nov 2026 17:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7376B05B1; Sun,  1 Nov 2026 17:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD0F6B05B2; Sun,  1 Nov 2026 17:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA6256B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:38:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33C45A88BF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:38:12 +0000 (UTC)
X-FDA: 85388014824.29.D216019
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63D9C1A0007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:38:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WhlDmhe1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793572690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyVD91132bU9Mh34FqVz6AEtmXuum78f1uIKiL1Rw/o=;
	b=KtPVBD7trfZqlixcIyawz9Q6cD2Z/I99U2xQM1Gdy7MC2/DcQe+SR1/bM+Ekk6kxAzAKB8
	4qftKqKIAQKmS3xsNmj/nslvxgMlvIyEmI2A/0DOf7/gAUDiBFuhphitL21CQUdkpeJ7Na
	Ga1pQ2wgF1AJHSCSrg0yK0n2LL8LsUc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WhlDmhe1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of shorne@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793572690;
	b=RD8O+L2dXiJ1luTG234kzNus7hedK/Mr/DNWhPfyB1g0ULVmUiuFelnJIq+nhGcQA7iES3
	RDBejTTnI4OYXtnxO+rM6VhCjI7EpXw2igAujs75S9VS2TW2tfVkDVE3LmS9x/7spqg5Ne
	GqD7hhwkpkEXUao9kVihKel+8IuvdVE=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so14248305e9.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 14:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793572689; x=1794177489; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cyVD91132bU9Mh34FqVz6AEtmXuum78f1uIKiL1Rw/o=;
        b=WhlDmhe1PgiAIEJiLzzyGDhzRw0p2VG8KSefQzT4ibeUaEduLbAsMr+OmxdnKZm2OH
         Cmzju6j8Eh2rx9eOjpIP+6TdGHN280dxNf160+XqbxTpc/HX904VupJfsiA6r7H15DYG
         ODmjUFecs++jCy28kEEcG1oTOYUbNIXnTBLBl6poKWuAWIqnM78NdHOv5pttBS6Pf3k0
         HFpvdupMP4KG4TQ0f/ZecqenqpsFptDxFdhCrzvOqe8Z+Dnq0QgZb/YYi6P+ejXu5w6o
         ugv5Dhl/t6E98f79AuN+gXvccprQZUeuxtlZlB84qZAZvCGVvDwJlL6gcFvp68I+6EuA
         LFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793572689; x=1794177489;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cyVD91132bU9Mh34FqVz6AEtmXuum78f1uIKiL1Rw/o=;
        b=a9/uGkviMnNumsxxKnplXMEX2QCmQDXN/+OrPmn6s2RPHTn+3s/HQaDLtgo5Fu+hQw
         8Tyz7zsRyW1DhyqWrIg4YRny6NZmmekfR0oVqXqNnv7QHLG7mN0fPUF4ezOHzCNgZndh
         bkasYFonKv5ykwyX2nlrm4+MuFG95cag2HC5oM2ezseQY1Sd1jVmpWDYriyJwiVXzUce
         akDZ7P9DYV/FTO00V4Dba7bV7UTsQ7HugPrvRS5JNI/Rz7eKCE66m7YBbD/+9JiYldrD
         XX8nf/r4YPfuMZcXf7K+/vwDbZUbqNNqvJq2bScC/y0spsRKyCVekAXuIvSPqndN5WGO
         pjXQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAfAEntaMXJvaw+nyXrg4/0OqglXono8bl0oyHzuELRn8hV9HdMf3mCMAoKuTIE1SJ5EFFV7xpSA==@kvack.org
X-Gm-Message-State: AFq9FYIN40k/fe3Dk4Cn/J7VIFnvZr2dk81OEglhri9Y9U75OzWM8Me/
	PiL+xuGaHHJQ7oSkVRb5sgQrTE5cBAJCldxcQwHJLCgb4VH+j+4I3FhW
X-Gm-Gg: AYBFou2Gl+PQkfGP3kdrhuc60cLap7wXPCImOU6nh9xiI8b1plD1ZiL0LwpJa+oNUSs
	GPbt1bBS7aioOeXuYm+lr0jj3E+EiTIniGdo0Ch1LRh0shp81S7XJHkro97TvzjvpMIAepXng4x
	68lm2B74SodFxIkMHnM7GFp67NOmO5RJMmuqpwhMCS2l37HFzleM3vi079zV4yA/S7MgCVJwRIb
	g1UXXrXZoncpdLKOLid5dLjdsktGVr8gWnFdOTbHct14/PmWHkamFqzf4aiAAb+Z377gsOFaUKI
	yiFaxYxHqKAQdxU1BaVHUZ8Vp0rwpCYt2XW3SiOw258My6pqWYZScgJ4i9MNm4LMOzSpKviAuoE
	N464OMDQt8RupibzAzaYAS8i31dLXP5K2eVKoRnqPYTtVSessnISfPIaDUS9qcwk8lO8QsZKspl
	2DdDaF7IA0QtLh6bDbpOggZIBlAJjWFs+1iuJ1oWdBo/7k+/pcG5rNiXrFq2B/kOAu7UrrII2BP
	N5UvIaomUWv0ZSaODSKWie/q0UBeqedTUl2wxCXN0/8BbTaJjBK7PFApHu+O+5+9JxG5+ImWN6t
	suOoiP+J8aj3SIV1vwEmSuqMHP04FLimme9nGoXlh328L2lTe5eVyi6GDzhwbeUsaneLeRh5qyK
	p/7jyaiskQ4tKd/eiNCIURh5BePE=
X-Received: by 2002:a05:600c:5397:b0:4a4:7a8d:c736 with SMTP id 5b1f17b1804b1-4ac16acfceamr186954635e9.9.1793572688638;
        Sun, 01 Nov 2026 14:38:08 -0800 (PST)
Received: from localhost (brnt-04-b2-v4wan-170138-cust2432.vm7.cable.virginm.net. [94.175.9.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f047bfsm297681255e9.3.2026.11.01.14.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 14:38:08 -0800 (PST)
Date: Sun, 1 Nov 2026 22:38:07 +0000
From: Stafford Horne <shorne@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stefan.kristiansson@saunalahti.fi, lkp@intel.com,
	jonas@southpole.se, broonie@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/1] openrisc: include asm/page.h before folded pgtable
 headers
Message-ID: <aue_T9TdK9MOIAOg@antec>
References: <7e6799e4a26d4c87b28bfe1d0bab7d54.1@linux-foundation.org>
 <aubrobg1lV24DH4h@antec>
 <aucp6NrW64B30tO0@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aucp6NrW64B30tO0@casper.infradead.org>
X-Rspamd-Queue-Id: 63D9C1A0007
X-Stat-Signature: u57s5ttwwxrnfuom1tb5i3stw4ba3tzu
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793572690-820164
X-HE-Meta: U2FsdGVkX1/F76A7jKaG1EXc4Pp//lEGSkgdwxSeH+PAzzWTEib1BFmJGlVcQsxvkxKcy3ULlE/7bC8FApreMTVKNCy896yt64A/cL2DDqkbB/0LvmZnGmAkIXm5w+1qEhN8QZaSfwIgccoslCyBrbZVFG5M0vkt1Qn5XH8oNdFRhzQv68aTwPFrBUvt3ZkSgfKEHuJjtn8WBJ+/vomwyXXaQV6/V++3q/KqbRf2RWCL+SE40+S1QwoutI+X0Uh30nJqkO/GXL/m6ru3EEZ0l03A/LV1CoacdNOihMI4H6oiQzRjmh7rtpnBs9567LsWCx+5A8Tm9XdbuNaotn65JTKWkysjG07Izm508Av0Mk/eD9Ur7SwMmeg4AhxQ7KR5mxFQuHgSz7KdLjqcpnieHAWbaUYtrLesjQTEt5WnMi/f+Ajc8B2cDbZ0kcMszO0U+iwOkkumZR77G4HL14DJo52Rk1dFPhwr2sd6XGKKc5Yq9UcpqX5pQcZ8kpZRbHNW4G8pfVDuD6WEVg/nCBVbXcPlqH36l2S5tjIIRz1Ko5rMsGw1BCWC8N91msWfnE2GKRSl4sClXgne/IPaKDTlm74jFZRhZVljbHJr53iASQdoT4UY+Vs6Rm6x1chL+OWl2t6avJKnnfaIqhQUULeSQpkGlGPmD4ut39Wg0wJJ33KiKY8MrRNsaRIzwXc+RKsHLolrXyj3iAqzRRZH+mJq32l0ERcf5ox8yKNWKNsBYuV18ws1dXTUOSrCJ7kvNlMFMaUUjRjpmOnvCWiItjAdn22FkKWAIXNRjQba5prpQ9J3Y1EyqLJNPKRE4bUMvKr3qyL6oAQn9IpGhYJE4Q15mN22j5B1ZnfHCzrC7GNGiXMXaX4e2mobXVPLrwrpIfi8wM+VI5aIWIAqTZ1cYxuKrpMgGRY2m41kv1o2wbvTQbI2zed6CVZjpmGZZ0ZQb6jHARvFEW2LIUP9SK3MDkV
 TE886UBU
 XMp9NWfqilDbUiVTTn1GM/VSJY7q9CnU7ttobjcna1EwBY5ExcpKsaGIOUyk8caRMGLTrybrgKMSD5MO4TQVtgObcOxruQJOJOA/UyTII5HtYWdZ9tjdGQ62UcZHFWofVCh3hIgR+9OGVlTV8piXtQsEMgc7Vlz00vAigyjcGiwqtpNV+aJr3JWJs/Us1vZYiCxwKdJke6wgAZ4R9d+AbjPtKVp7gG7XFJsKpjYGQf9FBpEyJ+7OVEEm05y87n3i8TWuwOVKzqknF6ed/oc1QO7s6qd/MVE1EIPPM8iBF+PYbYBHXcTzSIxz9kvtce2aFd3ePT6Lj7WL/LIAAQLmOCw9L8TYZHtsO7w1hN8jrkhrz+yzFJUVrdfnygGIMJq9/GF06tY7gk0WsGQbEbD8jGqckVmqIhULXxWbViYhR1FDwqKPJ2DULJ1c6/DeZKtPcU8TWf+Kww/ySuWgEbDGPqtiW1nxjBdJ/F0oBogTLJEHjFDDcKTRhOGSqjk10/PygiCnmEZKd5hOWPbpj84O9JrPoZhPMB8YK0icq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 12:00:40PM +0000, Matthew Wilcox wrote:
> On Sun, Nov 01, 2026 at 07:34:57AM +0000, Stafford Horne wrote:
> > On Fri, Oct 23, 2026 at 05:52:47PM -0700, Andrew Morton wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: openrisc: include asm/page.h before folded pgtable headers
> > > Date: Fri, 23 Oct 2026 17:37:53 -0700
> > > 
> > > An OpenRISC allmodconfig build fails while compiling the DRM TTM KUnit
> > > helpers:
> > > 
> > >   include/asm-generic/pgtable-nop4d.h:9:18: error:
> > >   unknown type name 'pgd_t'
> > > 
> > > The TTM header cleanup stopped including linux/pagemap.h from ttm_tt.h. 
> > > The remaining ttm_caching.h include pulls in linux/pgtable.h, which
> > > reaches OpenRISC's asm/pgtable.h before asm/page.h has supplied the pgd_t
> > > definition.
> > > 
> > > Include asm/page.h ahead of the generic folded page-table headers.  This
> > > restores the missing type definition and allows OpenRISC allmodconfig
> > > builds to get past this failure.
> > 
> > Hi Andrew,
> > 
> > Thanks for this I will queue this.
> 
> No, I'll take it.

OK, thanks.

