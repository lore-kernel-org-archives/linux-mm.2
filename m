Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBAECD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535816B0088; Mon,  8 Jun 2026 12:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CF66B008A; Mon,  8 Jun 2026 12:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422AD6B008C; Mon,  8 Jun 2026 12:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33D226B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:21:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B4721A0136
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:21:40 +0000 (UTC)
X-FDA: 84857261160.19.2519EBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4331016000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:21:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AHnbUd+b;
	spf=pass (imf08.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780935698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ct84BW5EnJo4ga+XD9TIj1NXZ7cJKFv0iZy7WsJtVao=;
	b=kzbyYadTx/+VBQ16EeWEvUam1jaQy/MMOTvcJ+UERXBAhDFPIMRWXDtQZN22Yj9goIawI8
	p6GzZiwTInO0VtRIT/wXEA4bTU8h97VUJEV2jvGJbleUED9WB5dU7X+RzdcDdLu2ONQHVy
	iryDXUDOZd23RKw3MRxBhwlwSMYmre0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AHnbUd+b;
	spf=pass (imf08.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780935698;
	b=PG/vfGrKTSU5z39jtl0geRxZspCspuF2R68OM7H+yOkDSNrH6T6LVnJ7uoKtqs9KS2bjFl
	5wKGc5Fj8FVrDUYAuDNa/yuzGqnbicV0OqdWIt8Q5C7CMoY9IsX9xQyN41158ngDpZ43WD
	/t+xEWecKJVSy3H0Y3DroGSscW25ook=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780935697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ct84BW5EnJo4ga+XD9TIj1NXZ7cJKFv0iZy7WsJtVao=;
	b=AHnbUd+bdUSezQGfWQPiLYvsMczUvUPunwYIKuoysIWkgJr3sFgWmxl+rBqDTcaKZ89KQO
	vH1oU6N/TRwG1sIyXQmbGgMPkFD4uuFv0ETaCtArwE8IoYIE8hQiDwzaTaSacryvPYZtN3
	D5fUOLoM/Jfl7eCUUmCvuVh6Ml56CyM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-7xgGlJFEN0uzEv3JnJQalw-1; Mon, 08 Jun 2026 12:21:36 -0400
X-MC-Unique: 7xgGlJFEN0uzEv3JnJQalw-1
X-Mimecast-MFC-AGG-ID: 7xgGlJFEN0uzEv3JnJQalw_1780935695
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-691ac5b31cbso1432914a12.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780935695; x=1781540495;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ct84BW5EnJo4ga+XD9TIj1NXZ7cJKFv0iZy7WsJtVao=;
        b=IVaNzpt17w5yV2jGMy3vNjePcZO/CqujxiHOoHaDyaphu4sqOWyCdyjjmwfz4aSZNW
         NvO3mDVcHLPZ+tMouWxNApujxYIWL09C+fCXq9ydnHGaj0bFRAlTUKPwTmWcU5WAR62p
         Is/+dln3+rzMu+3qBTMU/CmCazc6mB4FxjWlzlz5edqywiIVGAV/Lr2+teesxjP1E3Si
         65pfdiYxP1QzEmHtDjQpeTFe1sEOUDrtDr4MRfj+kso7NQJ8yJfsmojOiwe+xkmz/XaB
         xQIcqjvgZhE5AE/+Q5vXWS1XzXjhiR+Jt+bTXKG4MLn4ddmg0D/JZuzthWEkVfAKSe6x
         M+vQ==
X-Forwarded-Encrypted: i=1; AFNElJ+42h8lROefyXka2+mOyNokL8516IzhCbUfr9uGQoCj2Vy48NuIDd4pipFegfs2qkbbIGVb31E7vg==@kvack.org
X-Gm-Message-State: AOJu0Ywf2Ilohn40Xj+VDShcwpJKjdmgg65U3DI1M07CcGJlIqWktHWf
	5sRVL0mlsfczEkZPGmex3b89o2TB3whjwzCU4j8iTTG16jQr2anllwWKpX2nLb9y9YuEbxJn7HV
	dFe+/t1TZTvfav13IokM7L8gvc9BHiwPHCrPSRX+dfaMPoSlzQhSEn1Yo3MbBWuBf/aCUvlE+fw
	zxffZdFfG6VnO1Gx6X7e7qEFJgNISn7jxaZreTMA==
X-Gm-Gg: Acq92OGxR3TonrRRTQUwM+s4krb+6PbCatymWXFuEKHsa13vcB56B24DAJbxvMNxzv4
	MeNpTTuv06Vgy6jlA/iUPENITBHkHApFfFbzhMJFVxkUemkylvxbzT1UmNBC9qTVojAHumfvu3b
	ve4vhV79bbBYhlXweoO7oUPtLe0XXKCtLAyLTsg5+MPYgTHgDViXlVrsHxNax/iom9cUd5bi4mN
	w7Ov3dmzvvbuDoSvw==
X-Received: by 2002:a05:6402:3988:b0:691:6fc9:da93 with SMTP id 4fb4d7f45d1cf-6916fc9ded9mr3292155a12.19.1780935694777;
        Mon, 08 Jun 2026 09:21:34 -0700 (PDT)
X-Received: by 2002:a05:6402:3988:b0:691:6fc9:da93 with SMTP id
 4fb4d7f45d1cf-6916fc9ded9mr3292142a12.19.1780935694321; Mon, 08 Jun 2026
 09:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260527224848.1753560-1-chaithco@redhat.com> <20260602152022.2673803-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260602152022.2673803-1-joshua.hahnjy@gmail.com>
From: Charles Haithcock <chaithco@redhat.com>
Date: Mon, 8 Jun 2026 10:21:22 -0600
X-Gm-Features: AVVi8CeWJOu2Z1PIj-rgNdLnSdFg2ZdcZoZ0TmLnq61Q95XtGvSJdqgISczthmM
Message-ID: <CAMcbwu5=TK_EjZ=wN5fqLC-DVUendE+CBWX0pN7KBF+1ZwD7Vw@mail.gmail.com>
Subject: Re: [PATCH] Respect mempolicy when calculating surplus huge pages.
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PY64SH7jzyqy9AkJV0GAmt8MTsXtFbUexoA5-XrtWrQ_1780935695
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000006dad4a0653c0672b"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4331016000B
X-Stat-Signature: jh5j8pk47kj4rn857nna68o8ithec11j
X-Rspam-User: 
X-HE-Tag: 1780935698-665846
X-HE-Meta: U2FsdGVkX181ziymcDpdAPWQKIVKr4mOiiV3w9sYDNAW+tvYlfU8UAQvqGZMAmUyYeM/p/F3CoslF6Mdu7kKkMZqYxZl/GaIVYU16S1N9/oc6LeMgB5BUYJY6m9BJalj/Or8hY7gJZZowgZA2IJ+i0LibFt5xlHEJauVy2mPSLEBSe2oNqqlsylDwiGRqOnhce1qM3vC92IioUaSzO/XpXdCYOmfJexKc4crV7E/j55zcVi9AoKe3REIH94+ZdymtZ1Cw69vZzrcd2Yc1t2FxHbopzX9sAE5/LrWWa63QP4riVjBA9/v/d84PBgrqmfDt8PvzfywDR6E1aiaYcRPl4cnRk6gQgZVuJ01V4/oIsKWVxUt/yAzYnv5eND+OkdXE38nm0Xo8u9hjuSgmFKtQklsjEd1p5tUR0oOtVLGM3EUOwOc9F3OFUNUvgpsOJoViX0nGAmGeQIyJUr+86ju6HQngKzu2bQ+ipVPc2zCFO3jP1+kuHIzds+o/HmEF562MY9PcSF6wX5AzjUAEvJvXLLtMFsWMIIrWhfdDK3qhCCwEk5hpoNN0wGWSuyiSVzAiZjVcv/Qg1ceSysPe1utRO82tI1ARfahPC0gdPebDc7+cCMivkgxSqTVEZJoKzxnKbFry0/7/y1M2QqelNlcRFiB5XWCEhxCQm65mkysYhitXckcX6bXkDSorS8koQy0uGSJAFKlG/6bJ4qR7KWy7hjDWmSIMcK2/bcnh7iGTnuBr6eWDfM/U8ndsogOc0Ris1tL2Q8qvYY+DBhEoEeqqe6VFUd145r/7kUA+7OkGeBX+ZfgmEUcnJBSTfaeoWPcw1yW4haX059XliK34L9n7lw3rezKpFAAUXd5WL/gDdPJ+zm/H7MCQuxw10+/zPZ/mI+qxs9xgegQxyrxlJJv3h7C1+w+YhUt2M0eRIKFpADMCgCV3bbs8EHK59kjiiXJE3YBcyyiw6NXKl5y3jw
 WXELbjaj
 MMTxXy/wpKwf55c4t/1+lHP/a94deQ4PB5kUMW1GSehfx/3OKyu4V6lHCZY9IOhELxBpQoqH0jaVhdnHRB/VzdNsCg6vRyKNxqJ9qZ4C7bBYYxurBNMcQ2eNwmcQy9yISd9PmfQAX4ozoNPG2TEWYQ3vvZ576S89F16qt6sI1BmPskVV8IWBdE27QalAU1vGhcH96D/TjNduu/UkdkcYaSslK1Z3n3x/lOUDbvjl18r43f4JJSNet6vViypJVcVuQrjb40B1Me/T3BFPdfs7R8FARrcuBIAK7OKLhcyR+Kt+q0ZqO1xmmS5knU/NpKH6Pa1Vm4f5tPWF58pgwCNPe2ROlYRmiqaji7iD27WwVDpa76911DKSdQ5GUHTeJDQQrSGNpkM9TU0HT5m+Zy5yIpzo86w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000006dad4a0653c0672b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026, 9:20=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.com> =
wrote:

> Hello Charles, thank you for the patch!

You are so welcome, and thank you! I'm newer to contributing to upstream so
I welcome any and all feedback!

> I just wanted to add that it seems like this is a known issue. From the
> comment in hugetlb_acct_memory (the only caller of gather_surplus_pages)
> we have the following comment block:
> [...]
> So it would appear that getting an exact number of pages to allocate,
> and ensure that there are no changes with the reservation or which nodes
> those reservations actually go to is a lot more difficult. But I think
> we can do a bit better.

Agreed; actually, after submitting the initial version, I went back and
have been working on adding per-node reserve hugepage counts to the hstates
and adding some selftests for them.  It's going well so far, but I'm
hitting an issue in accounting where, after reserving a static hugetlb page
on node0, reserving and then freeing a surplus hugetlb page on node1, and
then freeing the static hugetlb page on node0, followup reservations on
node0 additionally count towards surplus pages even when there are free
static hugetlb pages on that node. Trace-cmd revealed allowed_mems_nr_free
is returning more than what was requested resulting in the over-allocated
surplus pages to stick around rather than be freed back. I plan to dig into
what's causing that, however, if doing so leads down a nasty path of adding
per-node accounting, I may need to fall back to the first version of this
patch (but with selftests) and be ok with simply doing "a bit better" like
you mention.

> FWIW, I think over-allocating is actually not fatal (although
overallocating
> by a lot is obviously not desirable) since we free all the unused hugetlb
> pages at the end of gather_surplus_pages.

Agreed on this point as well; afaik, surplus hugetlb pages are viewed quite
differently from static hugetlb pages where surplus hugetlb pages are "best
effort." Obviously we should try to reserve the requested amount, true
users of large quantities of hugetlb pages should tend towards setting them
on boot rather than dynamically.

> [...] I wonder if an approach like this
> could work:
> [...]
> So we compare the mempolicy-perspective "needed" and compare it to the
> global "needed" and take whatever. Since we are taking a max it should
> only ever make it more likely to actually succeed with the mempolicy-boun=
d
> hugetlb page usage, even though we still can't make guarantees since
> a free page on our node may be taken by a different reservation later.

This is considerably simpler than a per-node reserved hugetlb page count!
If I end up falling back to my initial patch, I will absolutely be adding
this and attributing you. Thank you!

--0000000000006dad4a0653c0672b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"auto"><div><div><br></div><br><div class=3D"gm=
ail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jun 2, 2026, 9:20=
=E2=80=AFAM Joshua Hahn &lt;<a href=3D"mailto:joshua.hahnjy@gmail.com" targ=
et=3D"_blank">joshua.hahnjy@gmail.com</a>&gt; wrote:</div><div dir=3D"ltr" =
class=3D"gmail_attr"><br></div><div dir=3D"ltr" class=3D"gmail_attr">&gt; H=
ello Charles, thank you for the patch!</div><div>=C2=A0</div><div>You are s=
o welcome, and thank you! I&#39;m newer to contributing to upstream so I we=
lcome any and all feedback!</div><div><br></div><div>&gt; I just wanted to =
add that it seems like this is a known issue. From the</div><div>&gt; comme=
nt in hugetlb_acct_memory (the only caller of gather_surplus_pages)</div><d=
iv>&gt; we have the following comment block:</div><div>&gt; [...]</div><div=
>&gt; So it would appear that getting an exact number of pages to allocate,=
</div><div>&gt; and ensure that there are no changes with the reservation o=
r which nodes</div><div>&gt; those reservations actually go to is a lot mor=
e difficult. But I think</div><div>&gt; we can do a bit better.</div><div><=
br></div><div>Agreed; actually, after submitting the initial version, I wen=
t back and have been working=C2=A0on adding per-node reserve hugepage count=
s to the hstates and adding some selftests for them.=C2=A0 It&#39;s going w=
ell so far, but I&#39;m hitting an issue in accounting where, after reservi=
ng a static hugetlb page on node0, reserving and then freeing a surplus hug=
etlb page on node1, and then freeing the static hugetlb page on node0, foll=
owup reservations on node0 additionally count towards surplus pages even wh=
en there are free static hugetlb pages on that node. Trace-cmd revealed all=
owed_mems_nr_free is returning more than what was requested resulting in th=
e over-allocated surplus pages to stick around rather than be freed back.=
=C2=A0I plan to dig into what&#39;s causing that, however, if doing so lead=
s down a nasty path of adding per-node accounting, I may need to fall back =
to the first version of this patch (but with selftests) and be ok with simp=
ly doing &quot;a bit better&quot; like you mention.</div><div><br></div><di=
v>&gt; FWIW, I think over-allocating is actually not fatal (although overal=
locating</div><div>&gt; by a lot is obviously not desirable) since we free =
all the unused hugetlb</div><div>&gt; pages at the end of gather_surplus_pa=
ges.=C2=A0</div><div><br></div><div>Agreed on this point as well; afaik, su=
rplus hugetlb pages are viewed quite differently from static hugetlb pages =
where surplus hugetlb pages are &quot;best effort.&quot; Obviously we shoul=
d try to reserve the requested amount, true users of large quantities of hu=
getlb pages should tend towards setting them on boot rather than dynamicall=
y.=C2=A0</div><div><br></div><div>&gt; [...] I wonder if an approach like t=
his</div><div>&gt; could work:</div><div>&gt; [...]</div><div>&gt; So we co=
mpare the mempolicy-perspective &quot;needed&quot; and compare it to the</d=
iv><div>&gt; global &quot;needed&quot; and take whatever. Since we are taki=
ng a max it should</div><div>&gt; only ever make it more likely to actually=
 succeed with the mempolicy-bound</div><div>&gt; hugetlb page usage, even t=
hough we still can&#39;t make guarantees since</div><div>&gt; a free page o=
n our node may be taken by a different reservation later.</div><div><br></d=
iv><div>This is considerably simpler than a per-node reserved hugetlb page =
count! If I end up falling back to my initial patch, I will absolutely be a=
dding this and attributing you. Thank you!</div></div></div></div>
</div>

--0000000000006dad4a0653c0672b--


