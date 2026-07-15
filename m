Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1766BC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030D56B008A; Wed, 15 Jul 2026 12:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F235D6B008C; Wed, 15 Jul 2026 12:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12D06B0093; Wed, 15 Jul 2026 12:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A58196B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:51:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02669A01E0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:51:37 +0000 (UTC)
X-FDA: 84991602276.18.B00C983
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1351C20005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:51:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGAhuTlt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784134296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyub/cJMN9WTSaubGJTQ1c5MFAOOywdVgLMShtM+vpM=;
	b=tt0dlD02SNaoUG1XEIDZoiYDSisjIcft+Rfs64gNpwR1yfyvwSyzRElMZ4o5OvL9JBYMAB
	np7gfy4I3If0h6FTzGDDp3WmJXV4UOwT6VOTBwgZE0o8JUg9IS+bSI/AKQIs5h2dIJ2qHV
	Kc/gDbRuR+itMW1UcVLkeEd7/v7CxkY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGAhuTlt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784134296;
	b=569Y2d37/hj4EpzSa0N6ZzhfB5el6UYCoh+E8vD7PmEX8yKCynXe+7ypHE2d/yrx+thkOk
	7rSgVwdFs1Mty07ntQXiDcw+QjR96C8iDmdSxL7Cv8z7T92iw5s9QQtCBzQCI83L7EFEzV
	m+NYIui549oK7DT5S2OfD5PJo1yq4VU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84874b52eabso3161459b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:51:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784134295; cv=none;
        d=google.com; s=arc-20260327;
        b=jm5Zl1R/lLWVbXd6uztqIhwFvL5MRz9hcrNafZmX80H0A+CUmNTq2U8Tga6CK6O5RO
         t++J5C2a8VH9yu5h6Vuwi0F2sAZ9L2zR0uCd9lgjaBVFglLG2m08bHITmFeoYvFqm0Qi
         Z/spDq9bDz6hPcFNmzjfBUh7x9o6pG8nY5c4c5U6PMYo67vrm3b9nwRX4RtqdnImEtrH
         mZf5vywWjnh51yaWwWYXbtkJkE2ap8L6eF0BpuE0KseC9nZfuO65dCE8d9iwl3T/C9yw
         370l18I/CCxiC1fJoifEBEb/WOCRrBkfo8DCBqdgxNWvSGSOaqV2mJOr3gVx9wOZ+PIj
         O8eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qyub/cJMN9WTSaubGJTQ1c5MFAOOywdVgLMShtM+vpM=;
        fh=7On6KiBkFTV1Zzsxq+q+eTM8tOyFiWKdyyN3IWpU4kI=;
        b=J/n82C4+GUm2fS2OK4HcfetqHnbWAJ4zAMOVFgAvGUDIKU18HV1mxZ+1TCPzlH5xEJ
         eTk8znG4C0XdSYcMbgqGj+4W1hTShk7DwJ5MnIScEXZfP8lRAyYqrwxSupusfyLa2Adn
         P7w8aIbCC2AZh/ZPICcOqHZn+iLAjGGx2xFxbxw7OpTWqr/Y8qb1bK4HMZix+q160b1h
         pvRIWu4eQ/FvYNm3X+5BL/X+zupDNbQruR/llQdZlEnEEqlGdvikU1Xw1Pd7/dyYalFH
         QoO2FeATQkBg01OiTUWu400faxfwhPlLx1mcUQf6/Co8GrD5Bwg0Y1IpH1nS9LjUd9ng
         KtXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784134295; x=1784739095; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qyub/cJMN9WTSaubGJTQ1c5MFAOOywdVgLMShtM+vpM=;
        b=LGAhuTltRlins4e1ZwZDocgXyXMCpiJFHHKr0ln8cChtUX6Nr+OLQxBC9LR88TsSFD
         WVU+44ItCda5ItNJv9jledtxTpKVMMq1nY6K1WkmdxO+YY7z4bw3p7VKLLtlXU+zsqHX
         h7+qtnO47ATg/AlXbEBumPZuHt8qECn23ySfE9C8Yjox5YAKPKuzVEDqCu584LyowY+w
         5+fsaQlcB8TlcQ1EkJYsrRK/AAmOZCIhXnzYXd8v5JU/NK+AOf0SQvoyyCkos7D/nKXe
         jL3DAESU3WYl+bIPtn7bphyW+6Yb6uUV7PWICRo/Cwdjs9dXYipvYDKTZzOOwJi1RdcI
         Hw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784134295; x=1784739095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qyub/cJMN9WTSaubGJTQ1c5MFAOOywdVgLMShtM+vpM=;
        b=VkMjMO9n1gGroEZG/455ENWznCSWSsINCSGibe4HXRb3mG4m0dFxi/ixIDMXItss0g
         3q/Hg0/4xv96IWxK/Mh+c5WXrINVQ4jRK6cop99JCppOV3qOXUXUGuCpMBJ3yIlss67x
         OBuY496daJs+TN+o4O9dXnVV8tv/Hpoc+ZksW73REpPMTpRvGuqUM7U3ohE74ASY7AWu
         f4nRT0ZhF9NtJH6TC1vees4dtGD7D6QMqiwPJOjF58LKjSRydRne63K8OQex9kBXXovX
         SD/SeCokMcK2rOMTpPGetrpuh4jUkazyIZ1YHcjSQgzqVltxb/yQ08hJ7WN82mpuzVhg
         0Kmg==
X-Forwarded-Encrypted: i=1; AHgh+RrE1pElXVjPNjlr4bjHwBkOF2wYwRkvERgVWVzLOhP3GvksW/hT0DuIZ7b8iWc40RVuCZjxXLe9Vw==@kvack.org
X-Gm-Message-State: AOJu0YzIRa0XcER9N12S/BV6QK6Gqe2Cv7XCn2puYJd/JOMcTy22zbk9
	Q0oj2HUPJNxorrJqg9NOqLpNFDNJlzOAkoPGnUYDLGSRE1x2qDgPc2+6MgHt8Iw2o8MYYDdmtFe
	cga6CzwAkaohVlzqxluyOnUKcFJK5g6U=
X-Gm-Gg: AfdE7clOgT5zdV/xRX91qjpLSNfv/vtx1MnsnrsRk1QVuiFL5cmHLiqgPVBlp7K4eFT
	WRwjzpJLhMOsLbnx4e7LLcUUYRRIXwM5c8HDJUYUGlx0qqQh6zSvRHmpTf7a/tmZvwvT/fvcmj/
	0RDQ+5z+oEnZzPF2LlvPw6HADMDw5Z/7KSUXTclvD5uUOmWeaGIGdUXGFB6UEfaND5cTUFOnvZ5
	sNORUJEK2sneF4c6WXYhgy1c+CrHYZ1s89+z9qDERO72sBmq7HvLC5e8nrDkHDB1WZkfBbib3AJ
	3OSUnb7IB9pF/xJfuu7jMbDdT7r5ExAjw9lQuTE1CjeQjwYXagw=
X-Received: by 2002:a05:6a00:cca:b0:848:2f77:e2db with SMTP id
 d2e1a72fcca58-8488979fc26mr16120085b3a.68.1784134294742; Wed, 15 Jul 2026
 09:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784096432.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 16 Jul 2026 00:50:53 +0800
X-Gm-Features: AUfX_mzqJfXF4kMKnRQ4pXaovzxFYUqy12jpj5tSbrLeV-ZIyu_KcjCEP1HDbCU
Message-ID: <CAMgjq7C47i-n-e=EGWoBvydp8mT3n-ZFeiLFpY=iTVDayucTRQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: promote mapped executable folios after first usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6759dh3oczf9jxbkrcnak898mq4a5ayr
X-Rspamd-Queue-Id: 1351C20005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784134295-230067
X-HE-Meta: U2FsdGVkX1+8thEkzuIAhQPpN2bHZRX9H+4UFEpctXdEkivhJvdqIQyBNuVbfSDswO6nmp0xk+F8Pbsq5oli5OzHNM6s4zz4fNBnDIB+zBIy2rrCRthuQmaNxfTfkGfPUr3Zm2qgEUlq4ic/5QpJqo7eNXbP+Tv2uq8zjkAXucyWefNbQK3kzwgub2NZYqd+QKFgPQ6VWthxQ8zu2uC4QtaktXtWptzeRZxCeiC92G+GRq3st+vLmSljP9f8kp61fAGdTMWojIaV/rMvP3VENBQOYO1IHu4pyVKT2T6rFfdjuWjOWfDrrol6ipBLmkMpBINrn88DrLg3Fugy7vEEH8SAJWqyjX3TwCKIsmzEc1CDaKYhaTLF4kvZRnR7eTpxpLT0NNhTcSITOd+q2B9MA/TXdWHtaHkSjUeSmfeGcztILPktpWZ30eJOcaooPsBc5zw9T8LwzIRW5tA9qbIndPLEowRfLMBJ8gzEfSrgIQ3aRx/316NQZpUHmD2xu5yGTbEAsLmKZpMlw9lA+LMvJEVQqANfj/9sqhpyVSrqzYnnjkGxGRflfEm6nl4ht/P9alwb0aqt2DukD15UFO5mb0Wru9QtCLrv5Y55qU+REF+bpJ21qNPZphMhHwobb7aFblcYQTlD2tg4SQ6msp6meV+Tz1+S6wN6dyabFmQxbGC+FGotHBKRFkUsOdFEr0E4MHJF8PqrJM6hJ3c+rFl3/30t9a2ebUPEMtf1zKkzIDT9K9iAdrfmQDqRI3AzldP0toXF3xmxnn9yPQAlHyc23TFM/QGfVUevqvLa2PRfr+BjNCNIsFqeXcFH04K2nmZCSG4j6v8WVpMlLZSQx1yyAr12B+kwG80XWk45U+22FaYD5hz2Qb27R13zeTUkRCwbCZXrETegi+hSwmjnhm+MJJXKKtGaCTRn7Q7hZA0JP/eEt0hQuCnHXqTG52lAZJ4VBYi8DEYft0TpWoMrQp7
 HNZdbAqK
 cuKXfivhWK+4p6qIWTeYKguyvFSnZB/WhKpiIkL94wUxVd1fZD0/teqa99yXd5GpZ+UZNhdSt83ha0O/wQxJfsKHfZV54c8Y2cNrHB0RuY+4z/hJxtrFpbI3Q7P1lC4LcJrgVoBN7rVKwy07ntajPyAq3ZZPgnh8TZ/mHsOwdBgJ8KQjzVpL5sUXTS8b+aljIClo9SVaC8tFzIgyTSLJ9tBGSOApsSMiokMU8HmpmJTX/I2kCGGiT6aIBlJOsOoU+N9GnRQYof7gCzVdhJUIrCQsRX04+xYLCzXHS/T+554eiN8qxLoaWSttdfeqUQ2mn8q9EMBit5oxodP3hE6MXjvFR3XUMOrdfxSzsfQdgwIemsC5W3gtU4bEP+LltxX8S3tSzYhefkH4jegWQuBffemngA/FfNITnM9tUDyNAyJj7wP/YiiPax5BPl44b8oXDQ56elC9eqBP5KlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 2:33=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:

Hi Baolin,
>
> Classical LRU protects mapped executable file folios through commit
> 8cab4754d24a0 ("vmscan: make mapped executable pages the first class
> citizen") and commit c909e99364c8 ("vmscan: activate executable pages
> after first usage"), giving executable code a better chance to stay in
> memory, avoiding IO thrashing and improving workload performance.

That's really a long history for those two commits :)
>
> However, MGLRU's protection of mapped executable file folios is less
> reliable. Although shrink_folio_list() checks references, the access flag
> of mapped executable file folios may have already been checked and
> cleared by lru_gen_look_around() or walk_mm(). Additionally,
> folio_update_gen() only sets the 'PG_referenced' flag for mapped executab=
le
> file folios, which causes shrink_folio_list() to ignore the first usage
> of these mapped executable file folios and reclaim them.
>
> Follow the classical LRU's logic, promoting mapped executable file folios
> after their first usage in folio_update_gen(), giving executable code a
> better chance to stay in memory.

Yeah I think that's mostly an ideology issue, recently upstream tends
to treat all folios fairly if there is no particular reason.
Personally I also agree that some folios are more special compared to
other though.

> On my 32-core Arm machine, with the memcg limit set to 2G, running
> 'make -j32' to build kernel showed some improvement in sys time.
>
> base                    patched
> 9248.543s               7861.579s
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/vmscan.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)

MGLRU used to favor and put all map faulted memory at head, so could
this be related to a recent change in any way?
https://lore.kernel.org/linux-mm/20260526130938.66253-1-baohua@kernel.org/

>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 986dde8e7429..429857852bdb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3188,7 +3188,7 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, =
struct ctrl_pos *pv)
>   ***********************************************************************=
*******/
>
>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int gen)
> +static int folio_update_gen(struct vm_area_struct *vma, struct folio *fo=
lio, int gen)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
>
> @@ -3196,10 +3196,15 @@ static int folio_update_gen(struct folio *folio, =
int gen)
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> +               /* Activate file-backed executable folios after first usa=
ge. */
> +               if (vma_test(vma, VMA_EXEC_BIT) && folio_is_file_lru(foli=
o))
> +                       goto promote;
> +

Do you think it's a good idea to extract this into a helper e.g.
folio_is_executable_file?

