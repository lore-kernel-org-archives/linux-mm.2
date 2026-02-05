Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C961E91263
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691886B0098; Thu,  5 Feb 2026 01:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669076B009B; Thu,  5 Feb 2026 01:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5923C6B009D; Thu,  5 Feb 2026 01:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4802B6B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:01:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A8A71C2A4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:01:52 +0000 (UTC)
X-FDA: 84409356864.23.8FE700B
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 046FE14000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:01:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BbkcYqRg;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770271310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mWheuy98QZQOkZMZm50UQN36EdHXhDRUEXaATEO4/v4=;
	b=ALjffauHE6QygguibmtCEcu+oYoMvaqx+65D49BL8psnao62gMTpbdfm4Gxfqn7bAZOdmH
	zIpWdc39AF1mSW8oDwnLwH9sNnx8yYBpW2RStKbG2uLiJ9xAnQydQGa3wq8NvUlAAoGV3w
	epGdS6iQodxzL6mdypKqy89jpq8fTC0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BbkcYqRg;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770271310; a=rsa-sha256;
	cv=pass;
	b=xMC8BiEVDCICmP/iOMD1SrNmfosn6B9JqupacyxskqWP8B19+k4al5JJcMDI+rTe/ZHOJv
	qm+BmwOf4V9OqWluY8pzhcDgVJEsYuxtMwvT7vO1PS8bHq/QLdOkNpcnUFIesdeIn/g3KW
	i2jG0ADf/tW4LxZ0keBT/yknHjc3cPw=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-37fd6e91990so5658951fa.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:01:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770271308; cv=none;
        d=google.com; s=arc-20240605;
        b=aV9hfinyZ2nBgRxQIg4jtBvcNkiWjhSQWTt196Ovgz04UpjTe7o7zUeIm+4QB3TpIL
         uWoa4Y2iuMtgi7j81CQlqdNL991gbtExy3mtIF6iB6zDu0IdK6znK/aGGAeuxJgi201l
         Jr546SJkYYONzgjMUEf99AlIA5VOK93E8S1VleX8fh7JgxzHXsMW/NcoTXJHSGPLfSZy
         z6dOy9a3MTCsM4f9fZzjDdSBeFBQSBL9OfAfiNR/jvjOB4tLAlbLztyOPLv6Q+jjLF7e
         DXl6FNKkAG7ghTUxQ5/rF2x1vlzlz/RDtZC8mwH7a6DvYe+59BIOsrDYFdZpCCgf+oYk
         2i3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mWheuy98QZQOkZMZm50UQN36EdHXhDRUEXaATEO4/v4=;
        fh=1oHiTMFT8HWKTsfyaxlIREwymfRwqi7AzOD5Hv7auuw=;
        b=B0Td72CnN2eLGNzRSEg/2VNXQN0H/4Ha/BL2GmM/bANcxWcPztef0l6RcYrTwQ7Q9M
         YR3cgYwjj1sbZ4ukiqw9InPOYCVAsRzMNL52j/PbbJcVinIRy0dcfaZBPl7uSEptq7uA
         x9cJKCZjrwONedDpowLv4/55zr/Fj1RScmNVAaZFN+QNuoiwjpd5inyPP3EkOleNXcDl
         Bj1iC8KuuN5BHc/sMzb/oAYU6f4lL9RyRpURtuDN2LBF7u3n4NdW4Is+1VMoY22aq29y
         lamAxD/xOtj/+U+HQWPCd42cQ4nwm164h03Iuc2FsLGL7YiUeC5cSICAwmIbXA4V/0rf
         hxBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770271308; x=1770876108; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWheuy98QZQOkZMZm50UQN36EdHXhDRUEXaATEO4/v4=;
        b=BbkcYqRg/1SFar2k0hrNil3pHfjq1aGt7G1rqJjDBAOk5X1pm/2+b1r5CO7rCoDqG2
         R27/i8OfPhmhd6nCSQSZx5VkPOp9ZAlf4e3SGgq4SqGrLMQfa5XrRH88mo5/9mOoF1z6
         jfkP8fXvuVXP3HgZIbEBmvhNVoBYj2CbdsvbiBLicP2Ov+WlFDK1Us+ZX5Hp7w4rxTF2
         a0U0NL4CMt6KRGqfsQSk3LKuGAqsVxbgAPLkSMe2Bv8Cdg5o8r2SGjaYSzpYMUyW/4aG
         M6nLBr01eIn1DUG2RDvxUwv0NuGBC8FtsJSrZffXR1PgPHpZ22IDqMzV9pFN/xQFt6Kp
         RRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271308; x=1770876108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mWheuy98QZQOkZMZm50UQN36EdHXhDRUEXaATEO4/v4=;
        b=KEa29UK3Hc14u4rEMSKQ080RdBGBdWmeLmFWo2i0p8mGPXRrEu60aeeC9PcnF/Nqa1
         0WyCwQkFwNWxFS8ML7gELWFhjf3oN5aC2oWCw8XRIquQuDtUCrws/Sl92UhlGjWc9lz+
         SPdB5h4e5fOLnV7OGC5CC5ff/GoF2dghvGEhI49pgtOcpEUGMqp/E1Ca0cfxwfZFfyV/
         V8Gs6gnGG+ZwOLB5k/WG3F3OuMrycLG9h909LeIN04uv8+zyd+AnQYBGwsP8bdNHsIPB
         HmzRAODJie8pj6ijFaVc2UObpbRWg2JlV1eQm0ig/etQW5+zbdqw56k8dLMEBCVlJwo/
         qNvg==
X-Forwarded-Encrypted: i=1; AJvYcCUNfX/VWJGzswVKzrj7Fn3iYGRsS9ioX68sNa47W4o+AcV3e+LrDEU4bx6T4WCXXPOs8AtBKT/0rQ==@kvack.org
X-Gm-Message-State: AOJu0YyLW0jY18wJ98CubjXs/+hAeX8x6AZVKQuYO8iMRHpRxFeVLN91
	9pswU/42d9Wt2TtgVvmp9ykvKtMC6r4jaXWVRsbMpiAOVoX8hs/Xm9Md7eRiCptHsDaCdCDLm3Z
	RcZaIUOzPwO2PtwGgo+6o51La86roYW4=
X-Gm-Gg: AZuq6aLm5pl+GVCwc9wp0+x9AnuTCMlVEZMgrTzyBurLVjxXWpRSgb2fO/YbRjX4PtB
	MRd5lhAi9TKUdToQctX1EdgH0631ChRcRWx1hJWguAXbYHgiwj2BcQ2V+SecWxompSzrhCl+DYG
	bBj9i2BYGhOIDRhehfLIkGmfztEgyL3cWAR7gpcK6obU59+c8v/uG7D4li2Sq+mL1sUusBq3f6z
	fTj00WxDdn+wRziy0X9DKi/mw8dfaoOVuEUVpvYnrSCgjfuAAPkv7dPfkaqHFtlmgzY+dI=
X-Received: by 2002:a05:651c:220c:b0:385:dde5:1bf8 with SMTP id
 38308e7fff4ca-38691e3240bmr26222591fa.40.1770271307655; Wed, 04 Feb 2026
 22:01:47 -0800 (PST)
MIME-Version: 1.0
References: <20260201122554.1470071-1-vernon2gm@gmail.com> <20260201122554.1470071-5-vernon2gm@gmail.com>
 <a5eca294-cb5c-437a-a48d-6c87675c59dc@linux.dev>
In-Reply-To: <a5eca294-cb5c-437a-a48d-6c87675c59dc@linux.dev>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 5 Feb 2026 14:01:36 +0800
X-Gm-Features: AZwV_Qj0aVbHQma-mmTgAlqMBhdlIkR6MfuI13bR6yBSYWjMBfeGX3-nKe2z4P0
Message-ID: <CACZaFFMnJxfwi6mVMXJjemS8bQaU_EMpj2RUG7=_Tt0HJMGdNQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v6 4/5] mm: khugepaged: skip lazy-free folios
To: Lance Yang <lance.yang@linux.dev>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, david@kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 046FE14000A
X-Stat-Signature: y7oxctngjd54w9i4ax4jb1zgderaw96q
X-Rspam-User: 
X-HE-Tag: 1770271309-607842
X-HE-Meta: U2FsdGVkX1/4iAaq9suk277kPY4REDOQp/fspUD0JfZFXtIuoAIiiG5zJCpurQB1VRGVj4wBbu2IoQhJDr9+3Sv5PxDqtH361YMFCql6aPRBOpsqIt71lUkfmIFAINXKU1Tt1NSZ1DI3qSMkz4uzDFt75RxyrmHg6gwxirX55B03djztjKRNiUE8OIB28v3tjdO5PMcOYaqNtsYEXoCN5PjRRHKooXYVDBYWjyOG19wqjKjSHTOeCu+lC6YXkH+TgImqvICmYnXzztaWzB6cofLnPSUaMwf4O3UXwJHZLaiwTA6SwlJw9URXZMzWWDP4wazs7MMzuR3uYFXgnwJETFb+nE7X3JufKMPhQ0TI4Z72fZHn62exzqnqKP04Jq0ejsViyr7g0q8nm+GY/FRQ5bLv9CJaFNGQbTp/6gqhlpvTm4y3xtopxqRPC/sXigYyJI1Ydk6YZuMRB4RiFsNPK/x3rNmux4URkkBLKDZMZRGOKSg3Je6N/hRH2TCxzVj5ZnI+tUQgGiVlQG7KcRUQudr826EBLg6FUYeNSSTRvGLa00GTdP3u1HyXIwqULAcwHgFjSZLoZnceQ1qpLhlB/djKfPi6at6QK5EX3WnXmw3ntd6oviNpNGU7kmYayD50dZLoUF3crXlwRRzxkRwdhxPiFKo1UUbrXkSTy660Wk4Jc/RIBnXkWzO+TkQb27a7OyAchSHdZqdEOzi6iowC3M36SYwpXREGuF29gZlv+PX6Pq6ceIfvuFI0tSSbVrhisGOVImQ5OZh6tx8TGgtewGX7UDC5F85tGLehMF9CqizaBvabPe14o1R5//AzlWiwjdlu6Z4xdHEOkaQ+W0eR6p3a2pC1wmEG2bR8Z7Aa++QOO8NOTGWQAPo49bchFeJq7aSCfSafaaKWzIOuABwVrOSRj/fnKQWdKNVztpF5uY5RbUoyDUj4AnfyBzAoBGzo3yA9guHW7g+fynMTK2Q
 X4Te9eHd
 r7QQ3sZJwFRE94jB/3Y+NOUswiCLU0QrGVkEuMqTBRHxOTSZJerz8Z+y821FrHQhPyIBdqccj4hSb72OUnAgJW2qXUvQF8ThH/6VORJNwyzaKmrAss8Zqxy9QkCgFB+OAIYmkJ2EM9ZiEGdi2FsgycULlH7g8SSRogbfMJC0QouxElXxJ1D03wjt1q0J9Nonl56ZcgRXTxWLddFTcSHQZfSj1xOFGfSi+vcIAcoaKI18YVn/veI6aeOHHDzpR5xLAfaWa67IbHVenr0uMy04yNq5W3Hufci7hDI2cVp8m5LeNPW+SLja42xL0qNTSBPhKlwvHay00dzEaUoxqV24sv4AtRFkC5tzdpjJOZNkZorWUI3K5Mc3eWUwPCzHtU2eaIt25e8d1agz61PN4/kI5gigGlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 7:23=E2=80=AFPM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
> On 2026/2/1 20:25, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
>
> s/andthen/and then/

LGTM, Thank you for review and suggestion, I will do it in the next version=
.

> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > And if we collapse with a lazyfree page, that content will never be non=
e
> > and the deferred shrinker cannot reclaim them.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memor=
y
> > will be freed, it is appropriate for khugepaged to skip it only, thereb=
y
> > avoiding unnecessary scan and collapse operations to reducing CPU
> > wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h |  1 +
> >   mm/khugepaged.c                    | 13 +++++++++++++
> >   2 files changed, 14 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/=
huge_memory.h
> > index 384e29f6bef0..bcdc57eea270 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >       EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >       EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >       EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > +     EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >       EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >       EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >       EM( SCAN_VMA_NULL,              "vma_null")                     \
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index df22b2274d92..b4def001ccd0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -46,6 +46,7 @@ enum scan_result {
> >       SCAN_PAGE_LRU,
> >       SCAN_PAGE_LOCK,
> >       SCAN_PAGE_ANON,
> > +     SCAN_PAGE_LAZYFREE,
> >       SCAN_PAGE_COMPOUND,
> >       SCAN_ANY_PROCESS,
> >       SCAN_VMA_NULL,
> > @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >               folio =3D page_folio(page);
> >               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >
> > +             if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                             folio_test_lazyfree(folio)) {
> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out;
> > +             }
> > +
> >               /* See hpage_collapse_scan_pmd(). */
> >               if (folio_maybe_mapped_shared(folio)) {
> >                       ++shared;
> > @@ -1332,6 +1339,12 @@ static enum scan_result hpage_collapse_scan_pmd(=
struct mm_struct *mm,
> >               }
> >               folio =3D page_folio(page);
> >
> > +             if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                             folio_test_lazyfree(folio)) {
> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out_unmap;
> > +             }
> > +
> >               if (!folio_test_anon(folio)) {
> >                       result =3D SCAN_PAGE_ANON;
> >                       goto out_unmap;
>
> Nothing else jumped at me, LGTM.
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

