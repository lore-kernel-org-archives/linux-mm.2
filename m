Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C0BC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65AEF6B0092; Mon, 31 Aug 2026 13:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5116B0095; Mon, 31 Aug 2026 13:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461B96B0096; Mon, 31 Aug 2026 13:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04B1A6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:40:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF76C1401E6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:40:03 +0000 (UTC)
X-FDA: 85162277886.13.A7EFD19
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 137591C000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:40:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iCzZtgEk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pratmal@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788198002;
	b=QuaIE6D6THEu27iuebd4EQMpZGbR+V3oXdzgqjSPjk0VLBGFbHi1Ol/KCcV80rZvOyYI8+
	k7ytH4tQlsqAduRlTKU+Xx9f7aCydIr5LrgYNPp8Xxds0SmxzH65ngyINbFbwsCOjBoaLq
	xBycA9lgBomrFZKPt7rNLrmuWDaFe60=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iCzZtgEk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of pratmal@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788198002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPpUlWXdLPVx8AUYyFYJrBOj8LsObV8aDyLIE/Vn3+4=;
	b=yy2u3Uof4FZazPHI02g9Dvd2QEpkQD+ll2SWU5yprLVefUQ1IwXjA0XUYDoi5X2AYqZIzn
	0ytIJmEZbBJemX7PgYEagb2Yy4aOSvEF+UWK1xTRLg0bbTatHRHYz/KKmOyfoJKhas+b0i
	awhgRsrZi38UtvsJMpmZh2EQdgTQnfk=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c10e86e52so9941cf.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:40:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788198001; cv=none;
        d=google.com; s=arc-20260327;
        b=Hrh9yjYzAxMsXGGYC1akl/oOw9dH9ReutvFuHOg4n4tkjZreeROsl8FxOgZ9HgZP4j
         pfwzh35lQeX01AVAO95TAh7Mn417JT6hM+xhY557ADv1ymab71596vhU+wC+FDr6wtL5
         /p/KAghzZsLMLyB2kiEJS8hWJMJnTBghc96/x8xfhs2CNik512EaOOhK1RUXdWPNN5d1
         h7VXMnPOy2jAxdTrc+y5wxknPfaxJ2Ta5cG+wVYYzzFeiFLpI//ykL09qS1mNSqXn6ki
         uoiKvBZy0tLGwLIkdwSUQnYGd8dnRbSqlsxSohVw96odvm4kP9VhKs1P+AGe7B0hmP3T
         F0bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jPpUlWXdLPVx8AUYyFYJrBOj8LsObV8aDyLIE/Vn3+4=;
        fh=6b7zxXgFSk+bm0zG16xNb/jj7reMxOZjmGBTc0wX5H4=;
        b=UlrtPRIIcuN4YE/ucDQopnhsA+uf+YmoyfMxiUXIyKg/kmiM3dHwIa+D3qo8wptt82
         zEqBE6PpHpQmB3riPS9Cf+vfJTX8EpFkSjorN5ZOW8rkJYI4rmTBTJMcPwHsGcKtiHI/
         osbdJHMos/dLzr+b7gLzwmZklsSCHP4n7LUXd8/Y5lo+stpTcqT7e8K7JP9fzIut68mm
         RELIjEjX9OLWnAnvWvYcIthi/RS8ZQiRydOJA96dt1Oys244/9+9QPYDF8vGppU5d2ZJ
         CutDSea+W39isWy45OYwowySR7PW0A3TBnyIdh4aPUpVDJ5Bw0cWjHgHcpqfZb6LT9Tp
         WwLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788198001; x=1788802801; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jPpUlWXdLPVx8AUYyFYJrBOj8LsObV8aDyLIE/Vn3+4=;
        b=iCzZtgEkI/R9KGZ2Wg14/d4ToLATXw9O55g3kUgKGq/OQY2keLizfyjB1IwECcHJBE
         vN8hCRb4EK52R/Rp4oWKnDRffzFsfOJ2QTYyDDzQ1uDJvCWmglIdLOrO1wUf+trA0ZTd
         8O03stpbrvTg5JBFRolRQzMf3a4pJwI6RC9UKy3MwAj+2SihwlylikUPMxzup1yEYC2f
         FoU6jqsENsh/bs/xhHV9CHFpppC4pCGRykTmwrP7fEuMyG9b6int15+w+JA5roS9ya5u
         BRyJ3v+HuzzbW27SWclC5JmGKuOodoBt3p0ZrbTsiAckH64/jbMz5e0VAkJTm43hNF/F
         94fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198001; x=1788802801;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jPpUlWXdLPVx8AUYyFYJrBOj8LsObV8aDyLIE/Vn3+4=;
        b=TfGYzOWSGYIbAk3O+55IGd84Azd1Xu8ZKdCn23f1d066WCr4+iFtwUgFippxML//Nq
         hp5lYQpMYHFKdLYIXua7PB3UKL6x6M1Jz2PC5YXRl4lNe7LTY0IM3uPvSMuRCZoPfgvm
         PZZ5s7ylRYPDRpnFNUpEnvMPsIvDhNyw4OBWC8rziyliA5Q6/6gfu1jkNiY790FZtEFR
         CrX12ODNRRtCstkAeX1PcgABWNty0aqmDOk3YH3dmo4A1sq+Amk2UnRh8RCakdHSwTHb
         eCHi68S8ES4auSseIug7cbjt5pv3f3VVwK6zxeWaeLQwIOpJgncsr8u+fWZJNx7Vc26C
         9JLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr04NkAcLha+GQkniZwNONWgocVFa6zvvLtivk5+wXouP5ohXr4KY0D8YRJHfxavkFO2Q2fD5rtuw==@kvack.org
X-Gm-Message-State: AFuF++meoWIhZjD7SJH19EyLGWGHVQSHluldagsWqNhuRSIgL7POIgla
	gGDl7mscuBJBHv3C6R1fqjpvtwvtGmJ0lJBkhyjOU3PPbl6ZBrlAEqOfAth4PmIZQvq6u6vGOei
	nbq7Z0RPDQjXO7JPMuDFJ6HDfwKW/84viIWXFJOv2
X-Gm-Gg: AR+sD11xwZjeTxX1rL182b8lU76WKi7oEJB4UMDmIn9HcOJSPBaDyOtZqqlq1/3jss6
	WATS+feBFCGsTC6YIJyEICfL4XkB+iSKjXpdikMd0qNs3tsmqKMSLVkeD/4YVRRyHXnaaKNBj2R
	2+r7jBSi5wh3CIPtHL9TmsWi/xv08shs6qS6aZtq0uu7Uslcl+XrZY4wDakgD8GQToEB268LvuA
	86uD5xwPY63ne8EhERzZIV6GhoiXiO8nbNJddSf6niOlKjhb2lTtp9rU1wQ7aZs/Pas+tdqbwN+
	qTrXZo5mKiMUKhd+aIKUfYHX5SyJTAeR3775djWeZ14spJKh5/pLXAO2dxpJcEuzc+7pNhswfKO
	JsHOo8K/zpA==
X-Received: by 2002:a05:622a:1f93:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-53024f7492cmr354231cf.6.1788198000536; Mon, 31 Aug 2026
 10:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
In-Reply-To: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Mon, 31 Aug 2026 10:39:49 -0700
X-Gm-Features: AcwNN1WbiF693Rdd2E2JcwoD-vuH4ggrPp0CxLZtVrgBpAwJ32geLRUoTBwXrJo
Message-ID: <CALHaPKfqDPo+4LSfE=Oq+JNrKyFyopkUsd86O6iKW2S4cBRY0A@mail.gmail.com>
Subject: Re: [PATCH] tools/testing/selftests/mm: add missing .gitignore entries
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000009da829065a5b4a42"
X-Rspam-User: 
X-Stat-Signature: onwmemfnx77f7oi6113ozt7pjtnqa9af
X-Rspamd-Queue-Id: 137591C000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788198001-551921
X-HE-Meta: U2FsdGVkX19TL3yqy3xu5a7nIxVHE1lUosT7VGGPGvc9WbuOWW3s5ELGRtLxG7EMLqYZdaVx+ggjFvLkjW/AoiGjoTSPbMp2cTdU3OhC5myhE4G2Y075lAYr6hoa3oo28x5IKY0WDVYskOQFkkbZ19vftwA1CCEoBfpXkIezqHo3wvSjAeYPJFgI7ozERyaLCmDHb640IiITk4sHZPQl7zuBMIbGHQfW93rcmRsxZzeyNebi2Dnpjs6j5Rjwa3GWFLQNuAKqRmWyC57FkJJ1rtxpPQo33/F0Qfg4bKEGeMX5fjtR1lDmm54WN3Cxc4lO4AtqVN/b5sONSItV+vEp2P4OHXIDJwNXWznIoXk6PjFmIi8W54wxyWroHgpNiwiSvbj6Gi/9bhkZgrHAfAsYduV6afkSD9Iy1jgVmYhcd/ogWyhl31JPMPHkga+RVF/0yKLGof7LwP+fBvSnjEjoPmq7xMB03G46mtqTNckYanWo9y7Io5RCkJIJ8NOCZXlhALk+HztXvypkMYcuyXEZJfkz0wctjBxtqQHH8rjiJDSesJN1O+gm7NhQlCcrQyWoBW3PGqs04qnX5uEH/HwWIFQy8v9u7hn3xuvrb0dITVzXCSLW91cRjclE4Di4yWiaT1QSjAsFJJ7Ns9liLisF0B4mdGURIPGLTqggpPwnenBD2lDf3cwg78mZcvh3VqP4Ox734J9iI46iChExFcjxqtEloe/d6jgsFWUhxHhVQo/I9KCPZW+L8Mz2bcBIypuiZNvil7cEGm7cSrx52375XVCFJLwOvi5p8Q1CFlc5UDlgWpSZYB7MqRUV6NTfMfiYf0PlCxRQenUUrWWaJiSqnRTN+ju56OxePpMP/7xuRamVoM627A0GaHvio/yVuizJ+0P54lCjObXDDkDomFUSocKfhfxMVxBi3C5xIjQQmPbdyD/fls9z8Fb14albK9Yu+NRLyIrcPpItZuYs2Pt
 uRna10iX
 IDwAoZimWrD7cweiIWNXz7NakMhamXjx0cNPQh3hBSJ2oTvcSB8so9PArfShW8VR66Zm4372MVaOnndSJoEcWnaln0qTIsjsSXeZlxa6sYC472nUbxnB0Ax1rBheiXx5+wxCYdJiyyiVdXrZecjHCjFLnQJTRhQbnrlWymNJ+yiugKbamQfR9u3/4mQamsMiGeYX0Le41VRO157fU7LrQpG9fEsXfSSzZgw71tMVILpmiml90+2ZRi5vJfTmZuOBc00zX99tYtJOZCz75Z+q1DcrK8c/d78+DW4+jEioD8Qo3Y7WpJq0gQQQUfBh5llEm7GADx0q6k0vkVZsQwmxhz5waHZqETiIVqPaGkTQSbVuZ8dM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009da829065a5b4a42
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the fix, Lorenzo, and apologies for missing it.

Regards,
Pratyush

On Mon, Aug 31, 2026 at 7:18=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg>
wrote:

> Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
> switched to a pattern-matching mechanism to reduce churn in .gitignore.
>
> It however accidentally excluded the page_frag test's-generated module
> intermediate C file with .mod.c extension, and also the local_config.h
> header generated if liburing is available locally.
>
> Explicitly fix both the issues, fixing the module-generated C file as a
> general pattern as these are always intermediate files that should be
> ignored.
>
> Since this is a trivial .gitignore change it doesn't seem necessary to
> treat it as a hotfix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  tools/testing/selftests/mm/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/.gitignore
> b/tools/testing/selftests/mm/.gitignore
> index fcd892ed21e3..a306d7754786 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -2,7 +2,9 @@
>  *
>  !/**/
>  !*.c
> +*.mod.c
>  !*.h
> +local_config.h
>  !*.sh
>  !.gitignore
>  !Makefile
>
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>

--0000000000009da829065a5b4a42
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the fix, Lorenzo, and apologies=C2=A0for missin=
g it.=C2=A0<br><br>Regards,<br>Pratyush</div><br><div class=3D"gmail_quote =
gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Aug 31=
, 2026 at 7:18=E2=80=AFAM Lorenzo Stoakes (ARM) &lt;<a href=3D"mailto:ljs@k=
ernel.org">ljs@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex">Commit 2bee308f3adb (&quot;selftests/mm: use patte=
rn matching in .gitignore&quot;)<br>
switched to a pattern-matching mechanism to reduce churn in .gitignore.<br>
<br>
It however accidentally excluded the page_frag test&#39;s-generated module<=
br>
intermediate C file with .mod.c extension, and also the local_config.h<br>
header generated if liburing is available locally.<br>
<br>
Explicitly fix both the issues, fixing the module-generated C file as a<br>
general pattern as these are always intermediate files that should be<br>
ignored.<br>
<br>
Since this is a trivial .gitignore change it doesn&#39;t seem necessary to<=
br>
treat it as a hotfix.<br>
<br>
Signed-off-by: Lorenzo Stoakes (ARM) &lt;<a href=3D"mailto:ljs@kernel.org" =
target=3D"_blank">ljs@kernel.org</a>&gt;<br>
---<br>
=C2=A0tools/testing/selftests/mm/.gitignore | 2 ++<br>
=C2=A01 file changed, 2 insertions(+)<br>
<br>
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftest=
s/mm/.gitignore<br>
index fcd892ed21e3..a306d7754786 100644<br>
--- a/tools/testing/selftests/mm/.gitignore<br>
+++ b/tools/testing/selftests/mm/.gitignore<br>
@@ -2,7 +2,9 @@<br>
=C2=A0*<br>
=C2=A0!/**/<br>
=C2=A0!*.c<br>
+*.mod.c<br>
=C2=A0!*.h<br>
+local_config.h<br>
=C2=A0!*.sh<br>
=C2=A0!.gitignore<br>
=C2=A0!Makefile<br>
<br>
---<br>
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935<br>
change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760<br>
<br>
Cheers,<br>
-- <br>
Lorenzo Stoakes (ARM) &lt;<a href=3D"mailto:ljs@kernel.org" target=3D"_blan=
k">ljs@kernel.org</a>&gt;<br>
<br>
</blockquote></div>

--0000000000009da829065a5b4a42--

