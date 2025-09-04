Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC512CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 08:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1717C8E0006; Thu,  4 Sep 2025 04:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EBF8E0002; Thu,  4 Sep 2025 04:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086D48E0006; Thu,  4 Sep 2025 04:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECC738E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:11:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9748C11AC07
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:11:47 +0000 (UTC)
X-FDA: 83850849054.30.05010C5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9DA9A0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:11:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B2l67bl+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756973505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pr0Y4bkCbfd3itfrxpuVGdfdmmRa0XxzBqHDc5t+1Us=;
	b=XsE8ETG0ObQ9gRhDhd/vRGf09JGdtZ8qLT877zUh5VMe9ayM/PXRkT81BPD6aIMaHus2uQ
	PsZsdX0R0RmmgMcMY1Oq+BXy22fG5VWCjy1aij9EAEyCebXQ+fQs97uaWB9dBWWnVkNyIy
	b/9nTreTAy6Z+HnQVgl7VF7N78jibUw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B2l67bl+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756973505; a=rsa-sha256;
	cv=none;
	b=c1FWL2vvrhLRSm5pUnA23+WAnVawQcM+Q9JHBYS3LcbjQFsTBatFUa0L6Brko7Q81Fll4Y
	EynVn+5mhq9eMCQ5cGPAxghRLqWaJGhP0fHDAGKUCPUiPYffh3mUXpVN6ABqMFfRm7XkE4
	0DY6eFDayZFq2DoEokrFpe922LNuzAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756973505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr0Y4bkCbfd3itfrxpuVGdfdmmRa0XxzBqHDc5t+1Us=;
	b=B2l67bl+nNRujWUMD3lhg3SIYL6WqrAO0fP0E8ZIrILnO27zydcsFfB4C+eAJgK2Prg/b4
	avJyng5cLjrUsVWYxBlvBe96bSykv3Zvh31g0ZVUEXnjzigwhlEay/5rjztrSCdKx8IgHI
	BOTg+401JqWdAmo2nv9xsFki/m9QsQY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-44yZFtgQN2Gh_XbvPEWQXg-1; Thu,
 04 Sep 2025 04:11:41 -0400
X-MC-Unique: 44yZFtgQN2Gh_XbvPEWQXg-1
X-Mimecast-MFC-AGG-ID: 44yZFtgQN2Gh_XbvPEWQXg_1756973499
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF26F180034D;
	Thu,  4 Sep 2025 08:11:38 +0000 (UTC)
Received: from localhost (unknown [10.72.112.19])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AD32180035E;
	Thu,  4 Sep 2025 08:11:36 +0000 (UTC)
Date: Thu, 4 Sep 2025 16:11:33 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: glider@google.com, dvyukov@google.com, elver@google.com,
	linux-mm@kvack.org, ryabinin.a.a@gmail.com,
	vincenzo.frascino@arm.com, akpm@linux-foundation.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, sj@kernel.org,
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com,
	christophe.leroy@csgroup.eu
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9DA9A0009
X-Stat-Signature: i64w63ogdiqggdxicb5zn34dx3xoujxd
X-Rspam-User: 
X-HE-Tag: 1756973505-998956
X-HE-Meta: U2FsdGVkX1+ikKyEwqxtYGObLSPEMWY6sRRcnUfQ3D6ObTvF7e90idJBRsDvaG1Q7nRB60PL+b/6clifUa4t/ZQduE0Db1J6OM4Qd7dFxoUYmWm/FUDgKPOR5VwWwjA/U2tWeXB2nSsR8wAd5xHPWzrVbTGlNYBJ3P5eUt814w3kCyqmd2NoE5fVKPXgHDZHVgxTiHujHIlsWN5HTcg9TKK2StXQXNbgOc5lJH+Kxn2hDIKqMXpsvrxoRPO462lImOj4fmghmz6UOjudsjt+AnvFy4aYwPayyGfV/G8uFytXtRPJc+bquumFhboqYIH1dLCzNrL1JR3qhRVpkC1S8r4pYnZsM9x0XsHGzLpiGnVgDuZxQq3wX3YLP5DSpFHFABSbReRWQMSyAu3PqXO+wH3yNkvyKy1BHYNJT5pPtdjHZLPMjD7H0+9xY216HcEgBTz6uYxJfnll3aZ4TbHZ2GrwL4m9YPxg92iFf601GGpS3b6nudorAHK9lstiVfYYrQotA4dFqd0Q8FfNURFG6vpdFvPd3xpTfuEufHl/VgRamrp+n/Y83K5poWwmOzSS4pncpWDCZ3kU4TK4/7azlCDUxE0yUc0JKkDbNoAEc/2eIzGE3k056h22wcNsuiMystgCX+x/j3HsJAMYeqcXQnSM1L80rwTFTV688hQ1SQcaPQ2mjFiV6jCkTIPBkq8Kn/hFe7hdkpxznP+UCPxu/T5heNVgp4vVYpCSDzNGzeP9inOnMVJuoGqVNagOzX+cus+B6LLZorkRDw1MPaA07H6qF/iJe3A21KPRnHXqEPC/+6Dx9Pqp7YIbg2d0kHvyBKIdDRDilpaMvtZFeB40cCUrKml4Ja+M3ydAl1/f+WWoWX4DX0rR0rFtgCs+WKwGdq18siWaxOC6qnJV356iMbSrAdgzMvYLS9JgCFR4ER065tjUfGPgxS0/iqt464ZpJPRYXVCWstD9j3X5mFC
 NnsS52BT
 cfVavaP62ZNsYQf3EdC8GS6bWqpeYhTy5O7/70xBglEcsY3hHMHuKiE6toMQvCi8Vx3smdJkkvD7MPmyAD/dM7ZHS05jBioYS5AF1mCki1L9pStqNs1KPkLxjIJWpKtURYDaArhQKoKu7d6CfHBAXi0z8GXFWOWwnFDFK2G/v6z9r+fu9Gx3ge5wtOEQM7Q8WsOfrZH67qYx2JmB/q6tzBOktAeQJmWexlagxBTJ0Ic8T4utbC8eULodATex6Di8fJS84jQJLBWenROVYs1XxPoQsDL/Mpw+yrn6Hp8SH2JtLphAOeWCCpP/8GsNIRIr2eEJxasPZLqGQSleggqyyA043DGBDcH0ier0ziRrgfo2iWIPXl+WvnK1N4xXMVHm+aFNRLkbg0y+ZO8dn1auRisNA1002rgNDaeTqnYzBhP81Dt0/U1sonR2vfhtHoTjmgiUuBDUfzSK5DUuBYHTxIeYL7Twu/D2/3dkyLfEaABXMIOEsMLtstS4FFTsINmpQB5lMav5X7cEhy3dW/0NTJFu/9mIsSqseEujiNM0J48B+wIsInnVoqJb79vNg/aUG7xel
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/25 at 03:22pm, Andrey Konovalov wrote:
> On Wed, Aug 20, 2025 at 7:35 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built.
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > kernel.
> >
> > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > kasan.
> 
> Continuing the discussion on the previous version: so the unwanted
> extra memory usage is caused by the shadow memory for vmalloc
> allocations (as they get freed lazily)? This needs to be explained in
> the commit message.

Hmm, up to now, there are two parts of big amount of memory requiring
for kernel as I observed. One is the direct memory mapping shadow of
kasan, which is 1/8 of system RAM in generic mode and 1/16 of system
RAM in sw_tags mode; the other is the shadow meomry for vmalloc which
causes meomry big meomry usage in kdump kernel because of lazy vmap
freeing. By introducing "kasan=off|on", if we specify 'kasan=off', the
former is avoided by skipping the kasan_init(), and the latter is avoided
by not build the vmalloc shadow for vmalloc.

Yes, I totally agree with you, I should have put this in cover letter
and the main patch log to explain it better.

> 
> If so, would it help if we make the kasan.vmalloc command-line
> parameter work with the non-HW_TAGS modes (and make it do the same
> thing as disabling CONFIG_KASAN_VMALLOC)?
> 
> What I don't like about introducing kasan=off for non-HW_TAGS modes is
> that this parameter does not actually disable KASAN. It just
> suppresses KASAN code for mapping proper shadow memory. But the
> compiler-added instrumentation is still executing (and I suspect this
> might break the inline instrumentation mode).

I may not follow your saying it doesn't disable KASAN. In this patchset,
not only do I disable the code for mapping shadow memory, but also I
skip any KASAN checking. Please see change of check_region_inline() in
mm/kasan/generic.c and kasan_check_range() in mm/kasan/sw_tags.c. It
will skip any KASAN checking when accessing memory.

Yeah, the compiler added instrumentation will be called, but the if
(!kasan_enabled()) checking will decide if going further into KASAN code
or just return directly. I tried inline mode on x86_64 and arm64, it
works well when one reviewer said inline mode could cost much more
memory, I don't see any breakage w or w/o kasan=off when this patchset
applied..

> 
> Perhaps, we could instead add a new kasan.shadow=on/off parameter to
> make it more explicit that KASAN is not off, it's just that it stops
> mapping shadow memory.

Hmm, as I explained at above, kasan=off will stop mapping shadow memory,
and also stop executing KASAN code to poison/unpoison memory and check the
shadow. It may be inappropriate to say it only stops mapping shadow.

> 
> Dmitry, Alexander, Marco, do you have any opinion on kasan=off for
> non-HW_TAGS modes?
> 
> On a side note, this series will need to be rebased onto Sabyrzhan's
> patches [1] - those are close to being ready. But perhaps let's wait
> for v7 first.

I replied to Sabyrzhan's patchset, on top of this patchset, it's much
easier and cleaner to remove kasan_arch_is_ready(). We don't need
introduce CONFIG_ARCH_DEFER_KASAN. Please see below patchset which is
based on this patchset introducing 'kasan=off|on' to genric|sw_tags
mode.

[PATCH 0/4] mm/kasan: remove kasan_arch_is_ready()
https://lore.kernel.org/all/20250812130933.71593-1-bhe@redhat.com/T/#u

> 
> [1] https://lore.kernel.org/all/20250810125746.1105476-1-snovitoll@gmail.com/
> 

Thanks a lot for reviewing and feedback.


