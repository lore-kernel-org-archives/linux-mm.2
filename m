Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164D0C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 05:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FCDB6B00AD; Wed,  6 Aug 2025 01:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4DC6B00AE; Wed,  6 Aug 2025 01:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911B56B00B0; Wed,  6 Aug 2025 01:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80B136B00AD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:22:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5DABC03B2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:22:37 +0000 (UTC)
X-FDA: 83745187554.30.91DED48
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E112100004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:22:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=re4ea+rO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754457756; a=rsa-sha256;
	cv=none;
	b=4xctMxyxq5nLYyNug/UKsCYcjKrOfaRDDPqM8gjY5HtnolYSrnf8DxnaSU5fquLWyiaqXQ
	qzsrdKiEuD0GfQup0xCp2QZjX69NRUSPPmdXOhbqfZja7fDteNJs05hYh9qBO39AWnNKJ8
	yl2tMDn2AKSiEIfK7LagUO7WybCcUuc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=re4ea+rO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754457756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjJbearcpYLygH3I9UtbiSxWfVYe30GcdnmkpjPEww4=;
	b=cftzgyqPJRwxnKxfRCQX7boOt7Q/owNm/LBldE1rcy9RSX7SXivRpAl7/ZP4gFexvaVj2f
	xLCdo6mK/99MkARTqpgG73mmTca+HnJ82yKWrc5UkH6qgg3zUgBFYpM/yUfC5rMr1Ij7q3
	aQ35lv+UDuXOPjv9sJFU6wBcz5TK+zQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8733AA568C6;
	Wed,  6 Aug 2025 05:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FD0C4CEF6;
	Wed,  6 Aug 2025 05:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754457754;
	bh=tqCPY7yIlC+Yf68lmUytU3qJt7wsROvcPOLHDh907yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re4ea+rOiDkRPbP1dSQIxPVNijlcfv44fS+v+vp9kuFffgaFQy1vooR7imTHnG+pH
	 OO69XmtKGK/0gH6ElDfarANP5veEeoc29NGQTMo8FmHe8CAr/TA1QGx+HNHk+I5IEY
	 cc4VDQsD5E1ykLpCmNo+m9AHzxQ+5PS+kq71vF+9hhjxYE7KwlsImRLIWJLcXRxSD4
	 9axI2l1nIbj182vNhjHas1HHAdUZOSxukBjYdJHmDH6O2waO4Q1s+BZ6b4d0EyM68+
	 YKl2DGc/JYw+xMU4bZBY8YYzz8kmmUDhOqpWDI0W58SY+m0OwsDQD9wsYdkwLnyAVq
	 pvIWOtA25O0RQ==
From: SeongJae Park <sj@kernel.org>
To: Baoquan He <bhe@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all three modes
Date: Tue,  5 Aug 2025 22:22:31 -0700
Message-Id: <20250806052231.619715-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805062333.121553-5-bhe@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E112100004
X-Stat-Signature: h75pdar9ep4xqujmkn5ghzbcg5i56kka
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754457756-232223
X-HE-Meta: U2FsdGVkX1/SIgKg29aHLTofGGAf3BPM0WJ+OSYKZxHOwQoJX331gXvdyI0wx9vaB6ZdilPDmq8dLmA2qRe3gfns9f1tPLSEV3eB63TmG166+1/bBWprQrWBGqupk1BxE7nMAB554grF7WB80o5WpZGmp0Nvw5Qc3E1MGDm83wODPBPv0hK+46aWQOun0UmU6EbanK+OcU0OfzOJ+C2HgX4pJG9H5CospGZ1z/LAtKIivOPd5agTrWUryOU2x4/Q+QaCDouaFIOYRLdf5x71g/cTm6Tod6ZVpTdFsDQH46gLUTZHH5aFjpwiHOkPS4siQdygI8E5n1XO0+r513b5fOtysQA4B2hgbpX+K8ZPqRx9m+ZLzKff/pLyWNAmn1HK6CmNm5ONDYouDOW03SwB9PWpJ60OhmwKnWLSFCwVyCJWFyt25FLOOqXmie3paZEYi99/K3rdkZ/Fb/g+/AhH+50wFoZDDTZrj+vuG8H9KYTbV4nepLhIhpkeLBpv+wXenIoVMaVKDO2AJQSB1mkUPe2DNq0Tc6fOljLhFppmRPGXtZz3ylItLbDRGo5WG3aD+4nw4Tm0+UiAunBlgezGBFTw7aD5MBr5HMZo3V0mvrkQnyYZAcgw0fHqSLyTI77DA7czXp3xr9O9VwdycgcaX/7UqGq7gmAzVd7TSWeaGrlzQF/Weho64OgLHLnCgqLHlquUh0YUkr+643wkCgU0hvt/yZ6hVPCCfFtcVYSMMGEtgUtUX/ltmCJNE2ErO9JKO2PSvMOoPLhJTZjMLIFvTzb7S0Eq9cMNs8/N7fs+RpeFJQW+axhyaMykJSmSZZESshOaWe+kmsmPCCMtWYcyr+nSWZmLMp0eRqsCsSHgjC2QhWb/vt9e9NrCLjmKLrB1ekG0csbZtv8neOYrQLIzZmSe11Mx7YHsm9vgfExsBcglck7mgOHEO4nx06MCRLHSsn+SoW8K+l+yyy5v2Tw
 JZdpB5yK
 yFjjcsqFccGqhasTXpNeshfW50TbP9ShJ8uQlzGSK3kWYmacZa+2OiBH8DnIv1VIVsUCYTkcD10BzzHGyYIPiQGhU5RUN8AYWuHkSAWFnZlXbP/oTZVqyx8Fssi1gsqLZJHljUosNtw86hKbHjCarGRPwnCCwwR5srDJlukfcgMqk5H16I3zFkM/TYbblIVY3tR0QxXJYLVCOBADTCXJVVIOe48+i7570Ir0IuESvfDzM43d5vAh3lOvFVLwp8CnbVsdaP+8ZZIXG/Xb3XgdMB1sAEkekhOU0Ka9TEl2WGY0J8Ht+gVGHecaxoo5qVJ8lWZdo8xIAVDbXDEjs07VdKe367A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Baoqua,

On Tue,  5 Aug 2025 14:23:33 +0800 Baoquan He <bhe@redhat.com> wrote:

> Now everything is ready, set kasan=off can disable kasan for all
> three modes.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kasan-enabled.h | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> index 32f2d19f599f..b5857e15ef14 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
>  
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>  
> -#ifdef CONFIG_KASAN_HW_TAGS
> -
>  static __always_inline bool kasan_enabled(void)
>  {
>  	return static_branch_likely(&kasan_flag_enabled);
>  }

I found mm-new build fails when CONFIG_KASAN is unset as below, and 'git
bisect' points this patch.

      LD      .tmp_vmlinux1
    ld: lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'

Since kasna_flag_enabled is defined in mm/kasan/common.c, I confirmed diff like
below fixes this.  I think it may not be a correct fix though, since I didn't
read this patchset thoroughly.

diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
index b5857e15ef14..a53d112b1020 100644
--- a/include/linux/kasan-enabled.h
+++ b/include/linux/kasan-enabled.h
@@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
+#ifdef CONFIG_KASAN
+
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
+#else /* CONFIG_KASAN */
+
+static inline bool kasan_enabled(void)
+{
+	return false;
+}
+
+#endif
+
 #ifdef CONFIG_KASAN_HW_TAGS
 static inline bool kasan_hw_tags_enabled(void)
 {


[...]

Thanks,
SJ

