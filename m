Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA86606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=obDZKewv
Received: by kanga.kvack.org (Postfix)
	id 4B6DF6B0188; Tue, 20 Oct 2026 18:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467FA6B018A; Tue, 20 Oct 2026 18:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357916B018B; Tue, 20 Oct 2026 18:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0689F6B0188
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:24:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C5861A01AC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:24:13 +0000 (UTC)
X-FDA: 85344433986.04.D5E4B05
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id B88AE80005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:24:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=obDZKewv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792535051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbcL9UJUoZzm8h4f8WZ8/x3EwYH3/2Tgl62Z2dUn4XM=;
	b=LY7K7roUhlluw+rrvO27nE+xJIBFJpbHhfX/e0P2Nmi0vN6pztEGAHhMxpydOG4NFCpS8n
	R3Wp6BwsEdVNrKmoi+QJK4LfRjpkLFCm/Kq6X/qFvXdUgiURkdR4IR/qnMg6zhvpcsFeRa
	KyG7RqvrtGZHB5yRcrfbxlq2+yQKSac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=obDZKewv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792535051;
	b=RDWZA3cvSiM252xe+hjgzcnVPrtlGAA2jeV6DbpFTZH3z1wAcmPwN63aeiA5RW+kznWROt
	VldPuRclCv/1CP8a4OnqKN4RXTotRxOerLcp4qGPuXd7hVL9awQN1zfr41k+0gH0WVATj8
	9nHRGG3q2c8tRNavprC11gtcQYwPGEE=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5363c8de563so1679681cf.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792535051; x=1793139851; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JbcL9UJUoZzm8h4f8WZ8/x3EwYH3/2Tgl62Z2dUn4XM=;
        b=obDZKewvxrxUjPrxMRurrTXsEY6V+2t39UmuMgwAI7OfTInxKeiwFuD0ZMwC4XnGzJ
         20pCFc8nzgfT3zq4suJQ2GlXmvVD/3R+Npk2FT2OneqURY3LikyhYrCUUm9qzqYkABnf
         Lny4WsuTPmr0kX3t1oS2eT0hWvekT+7j67IPUhsuDNuDRpCMM5PlUAiYlcMqA7isUJW9
         95Q3RmF4bBZG0pQjNpufpgsPNTMOLm/LkfCBjUQgn8P6riX/Kvc3dsGC8tQ/XMGG1GDq
         nWjT6gb3afnAMXGrtlWgVReLlAUL4ppUBpyGUvGJ6OmSzKk4cefCK8Pp7/LPp4RnwsvU
         a00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792535051; x=1793139851;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JbcL9UJUoZzm8h4f8WZ8/x3EwYH3/2Tgl62Z2dUn4XM=;
        b=OA2ajlgRK1aC0rTOJcPGiS4fY0XLU/U3qeJ/eM0qjT+UgWOqeEKaxom63m/68ViJs3
         nYB2IXW8qKGbk/O916jxcSYqKZMRSms06rmT5rIRdZeadT+So5RmOaNUDLGUz8+F39to
         s7a8+2EdHwMFjKV3pFzfyfJq6O+e1U+gATDKO7serHaMB+nOmm2ajUtcFXwWTCUEEnfB
         KDzbBNYvC+/b6CAgjBS+x6M3TAg6rx8+CMcCNMHvUrBoHeER3Shsi6rRY6yWww5r/Sl+
         5DztlXv6mOOhHjvKrs1IU6QmKzpx0uLKu6Ov0h0+ycco9mScoLAV5eTcPMeJ3UmauIhn
         pnIA==
X-Forwarded-Encrypted: i=1; AKwUvBzcwK00USsj3lLETa+sh5yBMJj1aucCmxB24lXOvk/EuxJy1FBaTk0DHPPhXQJPPesGsdldjG/PJQ==@kvack.org
X-Gm-Message-State: AFq9FYLXF2ONK7JbZxBVuPeeVnSu+4Qr0MF6ob7PGFWGUjgxLamI1f4U
	SGJ8fnm1YFgyR/x7JCK/2Wu4oK4VZczOKeYlmfTl97XsXUbGUbBGAI7s8q5Mf9V+RGI=
X-Gm-Gg: AYBFou1yJsGXVN6bCz/BWCKHnLBRO56ALZNXO3+NVJUIH5N0Ino1bO7HcjDwSxQo9Ih
	7AzOCA3nTo5M+EMp1h1U1Mj4W0IELp5OvM7o/sz9KAlyyU23D1vjPJ6Kfh1E5V45Gdfh74zM0Nf
	rxhtDvBfzWjKlBg6HJZ14tJvRFdgYngQlJOKljiueDYKX+Y6THeBepVys85hG18GEwZ9iCcBBkS
	NIBoG+NuL7HdQvh24VkXPsq6jb9nPl7WzY/VUZPDghnA/vTec/14aivLwy0Op2zuDiFb5lQqmnV
	wCvlRFsGppVcGa5MHG9vP4aVzeFcSIhIf80cDcKN8f5tAzDD1e0iSrs2gcp/MNDTMMMQm0sMriZ
	NzRHjAweT5x55oSlnj+xFtkvtKx2lM7PvMqjbn81Hp67tYw8qVFy53I/63/AXMKtk2eRVObscGy
	ZhfJeziPJtzaHDNrajaMX2TYfW9FM3Yi077LSqah+YtCv6tbi+oo455k2Eynmn/7ApSHTaX5ruO
	SVPSSU3F4Zhc0kZbO4jVPFpFT3fm8KxU3BlPvkxu7uzhzg=
X-Received: by 2002:ac8:5cc1:0:b0:535:f9dd:ce3b with SMTP id d75a77b69052e-5369bb816b4mr3355061cf.69.1792535050831;
        Tue, 20 Oct 2026 15:24:10 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53698b3d2c9sm6239981cf.14.2026.10.20.15.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:24:09 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against
 concurrent rebuilds
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
 mgorman@techsingularity.net, jiang.liu@huawei.com, Bessel.Wang@huawei.com, 
 stable@vger.kernel.org
In-Reply-To: <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
References: <20261019172346.3344005-1-gourry@gourry.net>
 <20261019172346.3344005-3-gourry@gourry.net>
 <45ef34c7-eea5-4813-b54f-3e34675697b5@kernel.org>
Date: Tue, 20 Oct 2026 18:24:07 -0400
Message-Id: <179253504789.1514232.10853151353341082033.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B88AE80005
X-Stat-Signature: ium8zby4egsx78mmwe18agzd1tas5omu
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792535051-870199
X-HE-Meta: U2FsdGVkX19YnoQoI/ml+GhS326AnrtsPNVv9vTWIywdLL7RuiC0oaZzwSu29OpV18ixVooUXNYwuNvlOdS/YgTn6IYJBYYD0KCher0Mgd3RzLWepfAmtwLEUzQl9tWZdySBI8fP3WL9btoU9USBLuh6UFkJYFJidbsUJCBYDQcSzvUge2/6DkXNTG15aQbNWGJO4yvzOPdAqJgds4blObAp/n1FOnE4lsUJnKVSn6h0nf0U24OjJKvHmwv2V94winX2ya2sAQrQMEbaP5X1q/tE8I7fJ18ruZmah4Ek2wgH6w5Z6pVmLtbWalSGwuea1SDsHfN4FgO7ytefosYInaCXTeif9lhWFDlqdn8uMuyicqZ7ELSU04cg4wOz/fY3/Tb+XNQGZaFH+ftRJGhMZ+gRSLaTe2pl8dC6W/mIKPJWjlvwELDzaGVg8EN9I74pQrdXLStAdUS9TCK2Zcj4w8XvjwAUyHzkPaNhhY0Y2PTMbvBa8vVdG24QwMSOU9ieqpmsfe6ky0miruGO0TVGESbofOM/Fc68VsDezmafDv6qBixjvhIXsb23C1ffUgWutChZF64V1Hs4HBm+ggz3++UFdoP5+7+ci6WTWwhsTlwKc3OU13aUNjEEsIAIBX777pSQ/LPOZ2ph4E9SNZdsxyPQYqR2Lf2Pp+Pypsnqh95H1MLo3NBmkH7wlZk/QU8SpFSCEfD2maAiE9iy0xNC9cGcfV+LlEuTzVbs+MljcZZfWPwXZe6whwXbJeeR3xtv37vp2YwiJYWd0QY9eQlqtk245cz/J90kzfRnhwKaqcVaT38Z1jMcb3EIiUwQsOB9UVKRYDFKzQl7kKVI6MDhWmmE4nMexvCNL3f9f4fXMgz1twISzQbodwIt8YIlPsJlfAHp65fATj3NqmAG1g6IucE3OQLDpCxBWxMSaRwB0nvHhw5KAkOjcOx/r8I1cUr8eMK+ufq7BQllhWmqRxi
 oY564FFa
 WIY7Gq68PaLDNthusIv5ofUgkiC3HKPf7iABPLwgH/ruU2iEt9Kn+2UhRqptpduIQAl3XSoD8mABjCoD1fczzV2RXBf1y34E9a8c7+NDMWCw9+SzuZg/T2ituMnR5yw46ZcKcAP67knAm8W3IkLvyf4dTY7e/1l6v3Ex02z52BEb5aCadtP5EwVmNcHFEiByGJsJOQvccVdnKxgjOSRL3ZjIMbwFGNE4/qa7FP9o4PV0V9tsRKSBoUmX8RrrLJcHWb+hsQcD+RernSyHS71wQrNcw4/lj2HEFB+Or+wvSKyKBVUB1HIOkBBQ4+9e8f9aMv5YVrl4/JAt5cD2ECqDerBO9t8n5qmGWMWPuxzYjv14056mDGbJiXEDezGHJPTVIXF5LA7WFzigTi/7i0LKT7kUKFnoC2J2DuJph+flWNHOHUVogA2pRR4TXDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 17:22 +0200, Vlastimil Babka (SUSE) wrote:
> On 10/19/26 19:23, Gregory Price (Meta) wrote:
> > Onlining the first block of a zone rebuilds every zonelist in place,
> > shifting the slots after the new zone. An in-flight walk can use a
> > zone it previously filtered. e.g.:
> >   - a GFP_KERNEL request can land in ZONE_MOVABLE,
> >   - a node not in the nodemask can have its zones selected.
> > 
> > With kprobes holding the walk across the online, I was able to get this
> > zone/node misplacement to happen consistently across hotplug events.
> > 
> > The iterator approves a slot by its zone index and node, and the
> > allocator then loads the zone pointer from the slot again:
> > 
> >   CPU 0                             CPU 1
> >   first_zones_zonelist(nodemask {1})
> >     slot 0 (NORMAL1) approved
> >                                     online_pages()
> >                                       build_all_zonelists()
> >                                         [NORMAL1, NORMAL2, ...]
> >                                         -> [MOVABLE1, NORMAL1, ...]
> >   get_page_from_freelist()
> >     zone = zonelist_zone(slot 0)    /* MOVABLE1 */
> 
> Since the zonelist_zone_valid() checks you're adding happen before the
> "zone = zonelist_zone(slot 0)" part, I don't understand how they can be
> helping here. Aren't we just reapproving slot 0 when CPU 1 can mess it up
> between that reapproval and load? Am I missing something?
> 
> Furthermore, since we have the zonelist_update_seq anyway, wouldn't it be
> better to use it to avoid these kinds of races rather than the more tricky
> way of relying on what exact updates in what order can derail the allocator
> side and trying to protect against those specifically?
> 

This does end up cleaner.  I'm going to reorder the series a bit and use
the zonelist seq count to make it a bit cleaner.

I also just noticed that the same issue is present in hugetlb (because
of course it is) so i'll probably append it there.

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

