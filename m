Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32204CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E608E00BD; Fri, 22 Aug 2025 13:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1188E009D; Fri, 22 Aug 2025 13:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B88D8E00BD; Fri, 22 Aug 2025 13:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03CC88E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:30:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9BB1A029E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:30:07 +0000 (UTC)
X-FDA: 83805081654.04.704ED5E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE25D160013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:30:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9NJWzVH;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=252UfE/vBQ9r0TEDviOY2kI9MCQU3kCqK3n/Zyt8oR4=;
	b=chV9YIp+/4dd7EXQqDwqbzFUtK/XLb2U5ImZuk0ToSxI0uVcu2RrX2zt83K94BvUGu3IqX
	Pp8tgzABUHanVj8pYJs2OIsaftWcT05tbBCHVtBt+z7xXC3OTNODuBriinw3e+ps01Q2xZ
	CfSJw2UerWMzjVAYqfs00nF8HQ+R/MU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9NJWzVH;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883806; a=rsa-sha256;
	cv=none;
	b=npdivfq//F4PAXDAV0fCPMz6Map1iZwWNRc1GVNvEQviYoJtNGZCbRobRFVtkcehdbkfX2
	Pns41/DEVIyFOPexnvuMUgfymgn8JJG/zSnSwitvNIvml2O13szWTP6irgjY7vNNo0SUJr
	DOP8lKKMUVHAjV5kR5umX/rya8f63Wk=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61c169a9720so721a12.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755883804; x=1756488604; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=252UfE/vBQ9r0TEDviOY2kI9MCQU3kCqK3n/Zyt8oR4=;
        b=u9NJWzVHa3mkSiJRNBk3hU9jyM9HDcei/xW4YHQYvuBqsvV7s7dRFqrPQXju7OVyV8
         n/av88UxmtyrbFjrfZDt07lp7xRSBuhojmbnnD/4msPE45KG+IpesueJM9CWXSuRwk6t
         q96mjUzevbjG+W5cUMsCL/BwoaKUouMUxIz99pk0WXunLfaf8gh4Q0zw5t0a27uDKM0s
         wllEbY/DFmiz9/DXSC1i2Ht3RgYxo07ISHJMNPZz8B8DTbFshlJKS6BpyzEVMP2lDbuG
         m4TC3cBox2qXcuuDAvEPz0IFFiOMfjRZ7NlgArEa7antill972QEoPVC0gFcSmwB24sS
         p8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755883804; x=1756488604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=252UfE/vBQ9r0TEDviOY2kI9MCQU3kCqK3n/Zyt8oR4=;
        b=RbnDa6V6gVPYdlUq/T8cSgPvuKhzAx/VrnBucTrUtyKu4tzypDeSOuJw2R5HdVNE9I
         cdu3ud9qICyEIVHGyvM2TL4Ibaf2N0wsHV91XP+kZPAztAX1wo+TRnaK7hclx21uDcHX
         4LN197t5xO06J7omCoD6904PWu0HiApjeOhkVDrI41mdjpb2xsitx8k+h5mX4KkNNbCF
         /S1hwsHbnmbCMavK6bBya/QVjZ6Ab9nktHo/lYpeqzJyh8Tq/Rgc25uNDKCSWKlQhFvF
         ur4/Aa8CJd0gKTjWB7CdVjjlRLd3Qs7mRXQ5KRWHmmeDo318F8djgHXw/u6BH7SfzqRg
         VGug==
X-Forwarded-Encrypted: i=1; AJvYcCVP9h4uv+DR2A4C48+DQzcdYVckWJRN7q4u0QyXDk9Pe8SloXbRBfYpzIJ9hBfl/bAsWWyvdI//1w==@kvack.org
X-Gm-Message-State: AOJu0YweWl95lrl6IYEjkwMGeLOK51K+7wI04H+Z7y/AQC9pEuTs+WQX
	FBdPzRfGq9HnuLvDFz1l590SHBqporjBAT90vOllrS0F+9GijMIT92kQNmAufN/uiYt/pj9x59v
	haLbTRfgT9XUjDKRCj5rN+kxNVXnTpC1ReO03NMiA
X-Gm-Gg: ASbGnct5qIOWQ4NDfE+guBdzmziX5DiVrXmZxFTmuGkaAo6cddqC8IDec35rdcDAgaB
	BGpydmkMhboLnUjyw3OqvKes1IPIaS4fRxI5oXibrXEH6Gre2fQnPYWTg3ScCIDIXU2N6BoCnJ3
	6M9SZOe293AHNKXH+HSqJParzKjllP8a2zC1D/KOArnFWv0vdazLtzD18bu0l1RXPlV+g0o8yw1
	INGiMQRFo375+cr93wwrKcWlNQHU/dV4ZFE+1Xav07d
X-Google-Smtp-Source: AGHT+IHnj5c0AQcYtFrhkC1wYBFb2YmVQM0FxMX03JVK1XoHfCrOErryzWCv9sPurRICdZwmIRfZ9c2Qqy8fv/ZcGyg=
X-Received: by 2002:aa7:c458:0:b0:61c:18b3:4e4c with SMTP id
 4fb4d7f45d1cf-61c1d7fd22bmr100263a12.5.1755883804135; Fri, 22 Aug 2025
 10:30:04 -0700 (PDT)
MIME-Version: 1.0
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 22 Aug 2025 10:29:52 -0700
X-Gm-Features: Ac12FXypkWhwPQn0ViSOI46R77FnBhepBanwmGZ60DMp2xuHG2FRINOwhF4PUNM
Message-ID: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
Subject: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 99tpinmohr595ibi73wshjntwrfybjxi
X-Rspam-User: 
X-Rspamd-Queue-Id: DE25D160013
X-Rspamd-Server: rspam05
X-HE-Tag: 1755883805-263273
X-HE-Meta: U2FsdGVkX1/+rJqwdFVmnfFW9GSMRkzq0V0whbOsoDAaa6AUOa9/h8ms+ie2khu61SPB3NLXhBboWucM+/C+F5YDxZJTVSnrunU/gZwFVz2ePaZmVlpK1WZhYng0DhUocAu7shWNq2Ctvy3a78+hGRB5nQUBizwhsCSWcRq/n33/4w5uDX2jV4YVUUdxRo7L3CgmFjid1r529dHRGBRw4MKL9dqR+uVsojCXh5UoDU0laRga4VvavNINGN0h6NDv1u4R+BaSHndtWqf4c2fOtw6oJjI+QMrGLH2JtR7jmJ/IjKlKKBUyBD/MyeOLZIEwhJUBosm4DFBI6T09+cH+fRbAqf+Zg596qOcIFgyZZmZbm31ahUMg3th3h4wWgnWFi5ms3Ue0HH/U9mJFqIOLfiULOj1hC3+0HN0WB9L+a3FviRQKEoeXQYajvjeDKqfFpDIHKXQXOfMZ37/EBXRaXCQe4ST6x5lVlQxEnXEaSDFpW73K2ShyZz7bImRUkJ8f0ROlN9yXYFHmQPhf/u9PG6VKqKE0wLNMxEmU/SGQns9fIzIRT4SN2u4me6S3RxEwTz3fgt4MA+/KKHaJPCRYIunSBwkTwDop/DaCqUVG40aBF7uoa/yJ0fWccj23kogzY5KKt0P5NHqpihIvXdsgkTUFR1kpxz3xPb6h4zkrpN20U/ucaJbvYL5/tebvovmRp/5ExkC9vSlIR+HAuKYGwyiOHHUzq461TGKayWEqlrXN60rk3rkX4bYhyi/QkgmAsHQSksIY02Gy/9Qn6g6g8rETer3U9IOzzWISSyN534YEAi3JGktI3/3JbWGgbx2gClA0QgIHWQWwC3s5C5z9EyzIMdSaivtpd0aksKLxS5SjTRafK/vNrd6UkZCuF/AJlcn6hLzacW1WYIqrtxqBdxG7aFFAVa86eB2Rz0g5bkUOZbLVOfPo6dwxf9Ub5pba58FcUHmrTiaBgIsqL9+
 qagrkAp3
 L6PTxUYFqaIhvqPvOD3oC3mLzq27P3INNRAirfZ82FHRs3/4yGOaI1Vzt31ZLKMXyPUBsGC2By0vi3/dkPAhKmzCZGOmr8FxHrggzHs/1pRpGL4be7Eapkjl7+Nu1+/pzggpuhUR4to0ZMpcYki3mw0YyRkP+OXwuqXU49HQ91/vOOVFG6y9VmDkYw07wZZlsxwqE4XgPbESks6xSuK9kk6qYeBBJzE2V0iA1bFRXEJ7QSRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Currently, some callers of rmap_walk() conditionally avoid try-locking
non-ksm anon folios. This necessitates serialization through anon_vma
write-lock elsewhere when folio->mapping and/or folio->index (fields
involved in rmap_walk()) are to be updated. This hurts scalability due
to coarse granularity of the lock. For instance, when multiple threads
invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct pag=
es
from the same src VMA, they all contend for the corresponding
anon_vma=E2=80=99s lock. Field traces for arm64 android devices reveal over
30ms of uninterruptible sleep in the main UI thread, leading to janky
user interactions.

Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
folio_referenced() is the most critical (others are
page_idle_clear_pte_refs(), damon_folio_young(), and
damon_folio_mkold()). The relevant code in folio_referenced() is:

if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
        we_locked =3D folio_trylock(folio);
        if (!we_locked)
                return 1;
}

It=E2=80=99s unclear why locking anon_vma exclusively (when updating
folio->mapping, like in uffd MOVE) is beneficial over walking rmap
with folio locked. It=E2=80=99s in the reclaim path, so should not be a
critical path that necessitates some special treatment, unless I=E2=80=99m
missing something.

Therefore, I propose simplifying the locking mechanism by ensuring the
folio is locked before calling rmap_walk(). This helps avoid locking
anon_vma when updating folio->mapping, which, for instance, will help
eliminate the uninterruptible sleep observed in the field traces
mentioned earlier. Furthermore, it enables us to simplify the code in
folio_lock_anon_vma_read() by removing the re-check to ensure that the
field hasn=E2=80=99t changed under us.

Thanks,
Lokesh

