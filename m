Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256F3CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0EB8E001B; Wed, 15 Oct 2025 04:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7811A8E0002; Wed, 15 Oct 2025 04:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670148E001B; Wed, 15 Oct 2025 04:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF828E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:34:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F9521A07C5
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:34:10 +0000 (UTC)
X-FDA: 83999686260.06.4436B01
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F5422000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:34:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hL3GS9d9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517248; a=rsa-sha256;
	cv=none;
	b=HM8AHRy8/umwdZ5QHyQdkr773GaDdYREO0AvSkgE1oGvvTVrYN6dh0YPK7dQyQpAVOD7kC
	yDDsF7mKPiprn44cJrl2TTdSvuoPFLU9ySqBWW0Km2elwAjVpsdvtg9NYS0RJDXqo/HOti
	6BCBZBuhYLd16uo+tmgKnQ1j4pji3S0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hL3GS9d9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of dalalitamar@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dalalitamar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UvD+dpk9qIdvSGdC/Ma7Kb6PuLSKQVrNtIj7GZm64sk=;
	b=M8WcIfcz1RbficRNKN5cPJKCGoQnYe2k7PZ+s4RUL8jITUa/DN+mYV8k3PmOPF44KYJSrB
	CjceLF3pLqDOxFeAqc8mbx794IU2n8FsrZw7H7U+j1dp7rZQTU8ZcH+DAc7jfMadmQsyM5
	Y0Qtiggzajanpma/qgLgJwJr/Sz7IRo=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7811fa91774so5451779b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760517247; x=1761122047; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UvD+dpk9qIdvSGdC/Ma7Kb6PuLSKQVrNtIj7GZm64sk=;
        b=hL3GS9d9BwVD4QpVwj9oRv+Udx3PBS3WhQCsxPAahUdIdmMQTKfq2f/0E7jmJkDQcZ
         ekrxISgPaoJlnlGOMaOHD4xbTYrh05GY1DVHxr6Ot/BJc+ADdkFXW4zPiksQ0B450pmx
         QvuGbo4kn25kGrTf+ibisccrw0dOQT2h4KDk+RayzmA0PTfjweNlcRwbEGw62MgtZbaO
         O6pNGv39/7QlEhAMzmslYa17p5MUTBYxrOMDuO6mv0xQGFcK2xb5LPeMWmQmo8ukRpz5
         H+xSms/zov69IKKKH1iOBbKrugpzTtQTyHFBpjx/oPtKz7Ly/96wFgRbhKCNMkyypY0G
         yCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760517247; x=1761122047;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvD+dpk9qIdvSGdC/Ma7Kb6PuLSKQVrNtIj7GZm64sk=;
        b=j21sdOAX/mnnet4pHXyOq3afkkyPNCJzr7tMhK4Oza7ofnmIHEWOyDjDcNmKX4zVEY
         nLyGVX0xNfARMkvZraVMCiF2RZNqmKA8DiNj2tlew2+8JMqNTm5AGNtdozuMQe03VDEr
         K/8iAsk8cqJxlcmxeyhJdAJLYh+GvcfUj29ElYwc2YSS+EKBgXdv0tQDAla/cZrgDPGv
         pzHznw2irPref57zms/+WJKvrJv9bT59BReYGuR9kNuKJLJPK+sZCsCx2mIp/L1ESNt/
         lwe90crtRb/LCt9NnoWlIReX6eM9wMr3T3/SrAyyDn/GdnucXQzvicfx5yvTIBWdvwPT
         Yi2A==
X-Gm-Message-State: AOJu0YwAp6p6WzoxzBGRee3GR4b9GGZbmOv00NIAeKdCuME/Fo0TD3Gi
	b8FeKUwnlow9uUnAxAsG6g35XzWh+ayfCM7O6swTTtijMK5tyhzSDgi4oaotKnk1e0V+8OgEa9h
	gf9tPf7q9bsX1vKalVuNET1pszXY1k0bvTqR0Nes=
X-Gm-Gg: ASbGncsr2l1RTk/viCktSP+DcrNoRw+0kKA2eIajgP6qAOtJh4GoqUeCoytoz9k/VaR
	6QAYJYs938REUsNkV8CBzb5SntFfaXmwlZfcBD/KNV9l5x5wwQ9Tcr7wfMnJu+YhC/wVLNyL+js
	rJ6E6bNfKX0QUTacFlsAi2tm/1+NslyJR8/8uW6npJAQ7gzncYlcqnjpWSOF+XRKtpt3UF1cZhL
	3on9OyUDMCJx7zB/rfGydQV51g=
X-Google-Smtp-Source: AGHT+IEr7Cned0gdhjbSviNtR+EkOPWQpYt/W0VWKq0OjLJnnpTZ17hpPGB8AS7UT/RG7Z+cKHjD2nOyatWea/PYrBc=
X-Received: by 2002:a17:90b:1810:b0:32e:52aa:3973 with SMTP id
 98e67ed59e1d1-33b51125090mr38930572a91.8.1760517246779; Wed, 15 Oct 2025
 01:34:06 -0700 (PDT)
MIME-Version: 1.0
From: Itamar Dalal <dalalitamar@gmail.com>
Date: Wed, 15 Oct 2025 11:33:54 +0300
X-Gm-Features: AS18NWD2W386-Lufr9QSTvKb06mASTIg40VOmS7FWj6e7r5724F90Nd0GhDx5rs
Message-ID: <CAJoePDqCd6F0ai1itmVATawqMQzB+JRi4NUtMJtxyeOVOT56VQ@mail.gmail.com>
Subject: selftests/mm/rmap: verify correct RMAP handling of COW pages after fork()
To: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org
Content-Type: multipart/alternative; boundary="0000000000001d84b006412e5dd9"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F5422000A
X-Stat-Signature: ath6d9dzdjhmi8zciikr3wypte3ws6kn
X-HE-Tag: 1760517248-448215
X-HE-Meta: U2FsdGVkX18Rg8ZZ2BoOi9yvx29A50NOiXb5Nc/CrkhhQS9zNvn1EZEkOdnU6+nbv7BIHN8U1rcJD5ctvn+UN5VCHSXjPSA3/+5ZG+gHgnaFz6TOYGhBHD7y2/eJhv60kg5Iv+rQoKHSff4RmsiCYyfojsOgbSibFOnyQQk8pZfOd09Npe5vvMDv2CIgTTukMWGWSg7poiG6bJhuKKukUPSxv5YgK7re0BcMq2cYn1DWk/YlUY18dTr8cKsgPevvR/kr6gaUKeEfn1bsN5uskYangO30xOuaDLAX85MBl3zd86+TrGdhQvWHSmi/cjMh3hNHEXRuefJVBx2UWY9k3L0xwi0MDQXnM9W+i8ZX5CjgQPDMYyJWfvLkFo77kIuV2qaulbJItXNPr5JfFcf6gq23b6jFs3hrFNp2ZkFzTVtX92WpER6AtmaBQI0K4vMIMZyeRS+zXwH7Yqn5iB52osJuqIkQCDDV9eq/n3rP3Lg8HduDfa2WtUE8qOr9nh6gjzet87YEUCVAqpdMAtjX8ppLaMzyAYkdbhqnZE/TDGnKS1MwbQy94rgJzOvjjR9i0tAnhifORVUefMO/YueX8r9Am7wMHN+IfzJZZHwJPm5FlORpwjHyg9lDYO558Hvfq04WVf3MmnPgfoAYPM+Cm4qthBDzdJBoUdUKjr2/ND214QVjTEvAcmeohGPfZQewwvOu2Y62kbquihlFLAIgLgTkS3aE8Gv4cRYAlZTlsQT9K/4Tt2XFDKaharolGux9WznZY6BwUgM3c1q9zplhzt0tRI+m9p1VdtpmswpymEMu4Ix4zfKv9vEpoDGIhw07bKSosZcs0exgsYKurKRV8QROx4S8/cgZHnqMjkn9ce0+dv/sI4J730hWzytkNMBCZTP+UiuMYmew1y6XgMoHNkMf/9pxB7Qqc7nuu3MQ00zDtCMmgSL11y/riqukci6VQf0QJVmxPAOo5exr1lD
 ZLyGfJXS
 bKOKeR9PeW/HnsF4821mVHTuGW+6UTyxzF9qpWIk2lJj5rJ0vX9UwVA45G3g8esV/D6MdMpBhHyFIxBK3MJ1vNwjNa3sMcLMaWYFuXOcDNS7NA55jyXSThwNs4XFYiHU4CRi0t0ClfSPLY79h3jFGWYJtY3UF1mDFURSTgayBVpjVOu/HPdAgnTpQ7OQ2BbEc6Cg0neDovXTDlgfTDqCAWHtZeMja4U9ich6smoYlV8eL0Jew2JjdGZ0g7DSehh1cuhUZ5eK/gp2faUT4klSOJ+rVvU9A0g0IgYw+eAAwwtbgfvnl/Um1kLAQgC7nZXM/HXOZVMUxHWa+i7ILyJQeAipmDrKG1nO42B3py7TOAO8NDjnl+kjuYkNpAyNUdK+90efoJ761OTjCYo9MtOD++UTjMuYGoP9mj25Biv8OjkcL2EOuX8oGYP1ET7emGOOCcmHqLCHqOIjuRaEwqYfBR5PldIPX4qFMWW2TE/y5mwrVQTw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000001d84b006412e5dd9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a new test `migrate.cow_after_fork` that verifies correct RMAP handling
of Copy-On-Write (COW) pages after fork().

Before a write, the parent and child share the same PFN. After a write, the
child=E2=80=99s PFN differs. This confirms that proper COW duplication occu=
rred and
that RMAP correctly tracks page ownership transitions during COW events.

Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>
---
 tools/testing/selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/rmap.c
b/tools/testing/selftests/mm/rmap.c
index 13f7bccfd0a9..2ba3361fecf0 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,47 @@ TEST_F(migrate, ksm)
        propagate_children(_metadata, data);
 }

-TEST_HARNESS_MAIN
+TEST_F(migrate, cow_after_fork)
+{
+       struct global_data *data =3D &self->data;
+       int status;
+       pid_t pid;
+       unsigned long parent_pfn, child_pfn;
+       int pagemap_fd;
+       char *region;
+
+       /* Map private anonymous memory and fault it in */
+       region =3D mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+       ASSERT_NE(region, MAP_FAILED);
+       memset(region, 0xaa, data->mapsize);
+
+       pagemap_fd =3D open("/proc/self/pagemap", O_RDONLY);
+       ASSERT_NE(pagemap_fd, -1);
+       parent_pfn =3D pagemap_get_pfn(pagemap_fd, region);
+       close(pagemap_fd);
+
+       pid =3D fork();
+       ASSERT_NE(pid, -1);
+
+       if (pid =3D=3D 0) {
+               /* Child: write to trigger COW */
+               region[0] =3D 0xbb;
+
+               pagemap_fd =3D open("/proc/self/pagemap", O_RDONLY);
+               ASSERT_NE(pagemap_fd, -1);
+               child_pfn =3D pagemap_get_pfn(pagemap_fd, region);
+               close(pagemap_fd);
+
+               /* Expect PFN to differ after write (COW happened) */
+               if (child_pfn =3D=3D parent_pfn)
+                       _exit(FAIL_ON_CHECK);
+               _exit(0);
+       }
+
+       waitpid(pid, &status, 0);
+       ASSERT_EQ(WEXITSTATUS(status), 0);
+       munmap(region, data->mapsize);
+}
+
+TEST_HARNESS_MAIN
\ No newline at end of file
--=20
2.34.1

--0000000000001d84b006412e5dd9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl">Add a new test `migrate.cow_after_fork` that verifies corr=
ect RMAP handling<br>of Copy-On-Write (COW) pages after fork().<br><br>Befo=
re a write, the parent and child share the same PFN. After a write, the<br>=
child=E2=80=99s PFN differs. This confirms that proper COW duplication occu=
rred and<br>that RMAP correctly tracks page ownership transitions during CO=
W events.<br><br>Signed-off-by: Itamar-Dalal &lt;<a href=3D"mailto:dalalita=
mar@gmail.com">dalalitamar@gmail.com</a>&gt;<br>---<br>=C2=A0tools/testing/=
selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++- <br>=C2=A01 file c=
hanged, 44 insertions(+), 1 deletion(-)<br><br>diff --git a/tools/testing/s=
elftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c<br>index 13f7bccfd0a=
9..2ba3361fecf0 100644<br>--- a/tools/testing/selftests/mm/rmap.c<br>+++ b/=
tools/testing/selftests/mm/rmap.c<br>@@ -430,4 +430,47 @@ TEST_F(migrate, k=
sm)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 propagate_children(_metadata, data);<br>=
=C2=A0}<br><br>-TEST_HARNESS_MAIN<br>+TEST_F(migrate, cow_after_fork)<br>+{=
<br>+ =C2=A0 =C2=A0 =C2=A0 struct global_data *data =3D &amp;self-&gt;data;=
<br>+ =C2=A0 =C2=A0 =C2=A0 int status;<br>+ =C2=A0 =C2=A0 =C2=A0 pid_t pid;=
<br>+ =C2=A0 =C2=A0 =C2=A0 unsigned long parent_pfn, child_pfn;<br>+ =C2=A0=
 =C2=A0 =C2=A0 int pagemap_fd;<br>+ =C2=A0 =C2=A0 =C2=A0 char *region;<br>+=
<br>+ =C2=A0 =C2=A0 =C2=A0 /* Map private anonymous memory and fault it in =
*/<br>+ =C2=A0 =C2=A0 =C2=A0 region =3D mmap(NULL, data-&gt;mapsize, PROT_R=
EAD | PROT_WRITE,<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MAP=
_PRIVATE | MAP_ANONYMOUS, -1, 0);<br>+ =C2=A0 =C2=A0 =C2=A0 ASSERT_NE(regio=
n, MAP_FAILED);<br>+ =C2=A0 =C2=A0 =C2=A0 memset(region, 0xaa, data-&gt;map=
size);<br>+<br>+ =C2=A0 =C2=A0 =C2=A0 pagemap_fd =3D open(&quot;/proc/self/=
pagemap&quot;, O_RDONLY);<br>+ =C2=A0 =C2=A0 =C2=A0 ASSERT_NE(pagemap_fd, -=
1);<br>+ =C2=A0 =C2=A0 =C2=A0 parent_pfn =3D pagemap_get_pfn(pagemap_fd, re=
gion);<br>+ =C2=A0 =C2=A0 =C2=A0 close(pagemap_fd);<br>+<br>+ =C2=A0 =C2=A0=
 =C2=A0 pid =3D fork();<br>+ =C2=A0 =C2=A0 =C2=A0 ASSERT_NE(pid, -1);<br>+<=
br>+ =C2=A0 =C2=A0 =C2=A0 if (pid =3D=3D 0) {<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 /* Child: write to trigger COW */<br>+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 region[0] =3D 0xbb;<br>+<br>+ =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pagemap_fd =3D open(&quot;/proc/=
self/pagemap&quot;, O_RDONLY);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ASSERT_NE(pagemap_fd, -1);<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 child_pfn =3D pagemap_get_pfn(pagemap_fd, region);<br>+ =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(pagemap_fd);<br>+<br=
>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Expect PFN to differ=
 after write (COW happened) */<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (child_pfn =3D=3D parent_pfn)<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _exit(FAIL_ON_CHECK);<=
br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _exit(0);<br>+ =C2=A0=
 =C2=A0 =C2=A0 }<br>+<br>+ =C2=A0 =C2=A0 =C2=A0 waitpid(pid, &amp;status, 0=
);<br>+ =C2=A0 =C2=A0 =C2=A0 ASSERT_EQ(WEXITSTATUS(status), 0);<br>+ =C2=A0=
 =C2=A0 =C2=A0 munmap(region, data-&gt;mapsize);<br>+}<br>+<br>+TEST_HARNES=
S_MAIN<br>\ No newline at end of file<br>-- <br>2.34.1</div>

--0000000000001d84b006412e5dd9--

