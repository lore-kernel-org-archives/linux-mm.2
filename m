Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F42C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31BE6B008C; Fri, 21 Aug 2026 12:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1C06B0092; Fri, 21 Aug 2026 12:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA386B0095; Fri, 21 Aug 2026 12:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64FD76B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:09:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1E8C801D1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:09:50 +0000 (UTC)
X-FDA: 85125762540.02.9FACC99
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id C444EC0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:09:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yy7n4fTQ;
	spf=pass (imf10.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787328588;
	b=FgRjVHYsOkWDTcPQMkQ0Fh+UfJs5upJEarTKwRciN55UL6KXACbXB7ul+m7waUx+WFdBuH
	i+3SDZCgU0l5iuI2XvW7372y8L8v/xzSj6SqdIoESDnUwt3e9h7jx7SFwxpBnVnfyW9oGw
	vDMpFZzRA0Og10Vn0xfsblMnRGAnMQg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yy7n4fTQ;
	spf=pass (imf10.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787328588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tazxm5NFBsMsYMGez4lAodAlGpJHR0dLcykvQtxWQkU=;
	b=3QbaGD7XF39gykUHPnwljMAGQWrzKs2941wlFQJ2cJk9XpJNe5yhbI8E2bLd9RIHQKeJk0
	5niWDNkg+9tpfoFA8vXAnJQTRQ5mJVE4NUF9cfnBg231HfnkdJy5QsRDcyATw8x9yqrccv
	7e/0oYa29WoCgvYF/RFE7ry7c+H1zWo=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d5655cc850so14969315ad.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:09:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787328587; cv=none;
        d=google.com; s=arc-20260327;
        b=LlQ7B+5Xgv8Kxh8U35cgl8HJe7Er3oKewAkt26zMdmTJznZ91czaFiUomqU1NulCPi
         QdRRrv5/xm3SO6CAUuxsHVehbsfz5GSLC2TX5Ttiay8bzDjN+v2PIzPvJ6H9fKmpHMo9
         pU9XD6IJs5gCNprAtLoRmYb7QSLWJOyurwNrr3XRW1gRJs5H5XuFotgmKb+h7mCwgmq6
         ys6IrQrdp5r8iYw6iX6XUjA53j10GoBZ0RXrkY8+L6SzWMbmKNgtdS68ssC1GDtEqpJz
         bAC17qxSs8Fbiz6ONrXnqhfFqXqEgWbdHflKUJqaMo8nw1LFF4KTY6Ym9dHTb9VAzk2f
         fZpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tazxm5NFBsMsYMGez4lAodAlGpJHR0dLcykvQtxWQkU=;
        fh=V7oAwzrMEH0m84WIy27n9YGPxoozlfhX+5zCu8QajpI=;
        b=rnSaAjM3CCxVHLQa4vCZCskvm6aYETJrAw5tiCiHL1eA9oMi2KCerN9X+H3rLp770G
         y1JgKRwwnABCmNi61/io1cBkd2scHo4njqhuSw8eAgFBzpeYKUKmTBxKDqqpp054YA80
         Pumo+uisQ79MjY7q+bKyUL4X3jvc7LE5P90dL6b309FZd6mFfH6q6p/xa4wymk7hR4pV
         yWA2Z8HQHziu1NMTXLBVUxEkA77YYF7WOaDYb/ycSbUkLreu6dXJkM4ttZiby2Lo8HyJ
         0/SZUGoZBvCtY5MdzYg6wkMZYAe7SydfaUVm95I9xSn3ioJ0MrVBYTxKg4JJn4wxJBj7
         M95Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787328587; x=1787933387; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tazxm5NFBsMsYMGez4lAodAlGpJHR0dLcykvQtxWQkU=;
        b=Yy7n4fTQxWXFAQ5s/FhRZZwzQObQExMVSP7GhDFF9L0OsDfFUbEvT4UCBrpw0tk0i9
         IWTQeY06/Xe4ywl8sbolJgq+tTsTRcepQnvJI0cZTPf935B1Ueswbd03nwgS0lxb/N8j
         vzHCmCfB1Nl3tmgh9xW1jfMxdX8U7HiECwwoMtvXPmdsuBxlMGV0CXyshVeXqPSZ61bA
         EtISbpSE/q4VRiD6eW5bJBOWx1UoJRbh9LCEb42sv6Q0uDljvII9MX4c5GJ4jIwmjoGM
         XhGw+bFMQje3uZ7hIODvt3yDuC5PZT1PqipvwApNrxRT5ZYFLmhU0VcJbwtj6cXSJNty
         KRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787328587; x=1787933387;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tazxm5NFBsMsYMGez4lAodAlGpJHR0dLcykvQtxWQkU=;
        b=f7GrUr4p21m7EPOJmkFjtd7v6GObE1+3g04eNw7kwTjuonQ9uupmxZ8Kncd6qdsyus
         K6fIqdAf8MoJdBgzBFxlbSRVxRsXReaYor1Vr4SsrgAMj0L7EAbT7zxLogzcRW6BAUui
         apqnVoWAC2SGnD3xeIkW1wV/hlo1Ls1qsrk0l4X/2GM8qZyE9kdAxw+NwkWqchp2+LO5
         TIo/nak01o0i+53HGk7pkI+nh3SvF9HKirCRmUbWsFKyydn32UkKUi/8SKAoMu9Gd/jB
         qQQzwFzhFRyuotqmPHUriV7B6tsl898yYLbrLpo9jkCDRSDxWbEWH8bCaINUOzirCLzq
         IhyA==
X-Forwarded-Encrypted: i=1; AHgh+RrynWKXODN1xkO/KEvHxjzPD+6eNg5E6QsDqfeWfeyg2Dx8Vn4o2Mbv6Xh3N6HGCH+QUDpg6doiiQ==@kvack.org
X-Gm-Message-State: AFuF++lAZ2893tYev8Q1UWfES++sU+fo5MchjpBE08cDI5749fZLEx/i
	xtydK/rXK4nr+NTn13zbA0zs7fOOmji8Wh+BCHeFBm93JsE++OLanYQoalxdIR7TWkTJWutyaYL
	U/SuxobA0pkWEIOZCgEciZu4r2j8Pn4w=
X-Gm-Gg: AR+sD13UOThqTT4cvyAXhd5xW3GKGbkdbfvfC7Vt8QWGkE1FjZdKU+fVdZuYUi/wXYy
	ciEqZ5DhWg/7nlC9V3SJQljrsc+ZBFOkBEQIA0nA+6l6DC4ohvTYr5i0OLoqVdOyCtycHeo8lUe
	eVSErceAe5PAYE3jDNOsaeffXh90qxw3hej8jmJEsezFSrwNXzBsntxWRrrrb3qYn6SUA+yXLUP
	MluPYdgx8v1KjnsGwxBMncIOB2B9aEp7Jx7B8t8BVCM0FFatnlvY0WqegrU6/8lVdgvVPO8yqxv
	MqW1YxyuHcuVTDBXzja18LjCOwxNj/EMtlQ4oFwUKCdyNRKXAj/aFgvHwEC8EMm5W0SjM+40u21
	/yBE=
X-Received: by 2002:a17:903:2c0c:b0:2cf:8131:75f4 with SMTP id
 d9443c01a7336-2d64b036898mr149534745ad.11.1787328587312; Fri, 21 Aug 2026
 09:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260821114416.12255-1-anshumantewari123@gmail.com> <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org>
In-Reply-To: <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Fri, 21 Aug 2026 21:39:35 +0530
X-Gm-Features: AcwNN1XKYZiaEhnwGrJCHIYlV_rZXplCdB7CN_bs-y4gxXJBSCqD5LOGANhLuA4
Message-ID: <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in parse_test_type()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C444EC0002
X-Stat-Signature: pxtg9zqw431ddzze77zip6n7ujqstemq
X-HE-Tag: 1787328588-658748
X-HE-Meta: U2FsdGVkX18+UNM+Jw8bVrtnDI5z3O+MvPj6g8L68UURdOVVZfMbMHrrbMznG015jYce+7zst5zKeed2WrupEOwMDznJfgVRfEZJEFwbL10ZIXvIUQTMoeqr/hwj79UcVO5+UATKLQuxCmVkRRSKZqcSffYhHy8Gz0BfahYCelp1fc6u19s5bbheDLGaWjJchb+yKuG7B/QS15pWtGaxZA7ie+NzYUa6p6mab1MrhuU3Phlk1atEVxrDWOMfW+e/0dE1ad/QI9jRKCLd7EM59Navjf3ngFal0LFbosDHAZieDGM9gwpRNDdXBbqD0eMbZduqMASP7JWHmeihwCjF7HJ0SOg4RCaamPrsuCw8LsF37Hb6AuoSiB6SkvfSkGHEmGOa32tt7hRnOC/pG2jKiJyl9U3qbjcjOyiZVCjIGZESJysyDt6IQMOLh9QSUsTMpWX8F1X0VtJ6w4hjazPiMRfRP5UDc8QdBij+TrhPVhgylwBuRDgIMAFal376DGcX6YV5PCA76DtkIfaCW6vYYwMYTzSQ6IEa/YYgK91NMfaK4ic92X8N4FqMPaaqeYXZjV9+Uew1TdcgklLVQ+2eeqO8U6nz/g9veMl9FxlbXVccKfa+E1vXVJ5pptND5PGCXdcqdKkewsuUtdWY5bGBT86JaFQVMNX+bfl0QS4QuZ2ZclQXChpS6gMcBdhJqU7TzqyfN41Hflsr6dfg9g4Z53uDK6RNiKMD+HtRfqk798aZswVyuPgCPy3uGGuNHeTkE3GfFxxzURddp/6L/HRFKRNrd1YRxyzCiCL4CjP1IvY3Qm73WOych3C0uXGLTMMD28KtTcf/K2WsvC3yPyPqP8dj0Ff7NVI/aR61BVj7pH3kJr3kj+EQMa0Tann92sZx8ah6hTDtcJrAjkovQ8EnyiIlGoynNU9cHFrgPP7X6UqYWtM3WeFCQhNbeSe4rxZwG7vDSZfBWF+N/J7HzZX
 A5a0Cs5d
 TDl6YIrADmiTNYiKQ5O0bFmNmTOL2bp+kSxlWs/iVFo6uti8llKu/Au5rYSO7A4nuzuX3BEfv01/DTUqK7+1ZMO80KFlG6+anUpSKL2Z4ZH9u5may/2J/sIE46+mI1tHDkaOyreo0ErAO38zQP7bWpeS0F+CHDygiEhkRWbg4vVfki0iMJ5GfVmEYrZ8Ai8LFKFI7CcV9rfnWfUS7ka/QhOW8msOaIvx0SvqGv96wIsbw3owdFeo96t3pvkty9YqSPPdi2qVCB2G/lABwyI0ovY+Q7cPqfezxDbV54sKfYQDXDUsylkFe16nbWDtKGV+nBScTc9zGxQxtUvDnBtVmUVMfkuZ91GL/Nny8jpvORvsJfvDfyfBo0kmJbHVppuVRlXRPk7LO2JCWQ8o+DsyAOmVxFYAkYC2IsWNI99DFkKOgYFT1iujMjiReS0VAPpl/sVG9VnMEdjc8RvWT/TVzprxWNSJs+5Ef8nxDSKa+SmwjBVZyw6/HgrmnG/15CATB9PLdSiww4P2omt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David, agreed =E2=80=94 strdup() is overkill here for a single-use
parse, and dropping it is the right call.

One small consideration on the approach: working on argv[0] in place
means strsep() will overwrite the : separator with '\0', so the
original string (e.g. "khugepaged:anon") ends up truncated after
parsing. Nothing today reads argv[0] again afterward, so it's safe as
things stand, but it does mean correctness quietly depends on that
staying true =E2=80=94 a future change that logs argv[0], re-parses it, or
echoes it back in an error/usage message would get the mutated version
instead of what the user actually typed.

If we'd rather not rely on that invariant, an alternative that still
avoids strdup()/free() entirely: copy the type argument into a small
fixed-size stack buffer (with a bounds check against its length first)
and run strsep() on that copy instead of on argv[0] directly. Same
benefit as your version =E2=80=94 no allocation, nothing to free, no
NULL-check needed =E2=80=94 but argv[0] itself stays untouched.

Happy to write this up as a v2 if it seems worthwhile, or if you think
relying on "nothing downstream needs argv[0]" is fine as-is, I'm okay
going with your version too. Your call.


On Fri, 21 Aug 2026 at 19:49, David Hildenbrand (Arm) <david@kernel.org> wr=
ote:
>
> On 8/21/26 13:44, Anshuman wrote:
> > The return value of strdup() is never checked before being passed to
> > strsep() and strcmp(). If strdup() fails and returns NULL, strsep()
> > returns NULL as well, and the subsequent strcmp(NULL, "all") is
> > undefined behavior, likely causing a crash.
>
> In practice this is extraordinarily unlikely to ever fail. :)
>
> So I don't think we would ever experience this.
>
> >
> > Additionally, buf is never freed. strsep() advances the buf pointer
> > past the first token, so by the time buf would normally be freed,
> > the original pointer returned by strdup() has already been
> > overwritten and is no longer available.
>
> Given that parse_test_type() is called only once, nobody cares.
>
> >
> > Check strdup()'s return value and fail cleanly on allocation failure.
> > Keep a separate pointer to the original allocation so it can be
> > freed once buf is done being used, after all parsing has completed
> > successfully.
> >
> > Signed-off-by: Anshuman <anshumantewari123@gmail.com>
> > ---
>
> [...]
> That's too much churn for something that is irrelevant in practice and
> makes the code more complicated.
>
> So the following is better I think:
>
> From 36d525409eb16f56e667b2f979f2c6ef112ff235 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Fri, 21 Aug 2026 15:57:57 +0200
> Subject: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
>
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just work on argv[0] directly
> and avoid the str_dup().
>
> Nobody after us needs these parts of the argv[0] string.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c
> b/tools/testing/selftests/mm/khugepaged.c
> index d3a53673e1f9..7520fc0483ac 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1226,7 +1226,7 @@ static void parse_test_type(int argc, char **argv)
>                 return;
>         }
>  -      buf =3D strdup(argv[0]);
> +       buf =3D argv[0];
>         token =3D strsep(&buf, ":");
>         if (!strcmp(token, "all")) {
> --
> 2.43.0
>
>
> --
> Cheers,
>
> David
>

