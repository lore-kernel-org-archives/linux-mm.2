Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BBED58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 02:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5160D6B0005; Sun, 22 Mar 2026 22:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C73E6B0088; Sun, 22 Mar 2026 22:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B55D6B0089; Sun, 22 Mar 2026 22:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B37F6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:54:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAB79BBEA3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:54:11 +0000 (UTC)
X-FDA: 84575808702.21.AF99B1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 97F8710000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:54:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKnAnWHF;
	spf=pass (imf05.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774234449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jx23AGpC1KRCKLBNhmCjUz1NFVaJ2RrysRQP2TgzV8c=;
	b=ZQ2U2wNMVoAMIxgzsGzD8Iim2dV5Zz+OVJF3951xr5wdI2syOyNlY39mUIsMBQoJ8HMFt0
	9oeauABSVbp1j7Q3/R232fHlnGGjmrUnbLP2Kfe5LICOwcUVoIO+8p7pbScOEmZAuapg4f
	5O5YJqXMcuxTMJo7zJYwvYirPVCA65k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774234449; a=rsa-sha256;
	cv=none;
	b=ijDZJGs1odCyN0l0wh8ib9tlEFFhVAQUxFvHBxl/oHCu1/6fptcy3YodXwHZp1ZEr2Rnbw
	8/o9zt3BJ8aqD67mG5bDvUlPuvh2X9rAwhL9qxHCjWx1Nl1UaSnA8NbAW3ibuexFgcSHS7
	iXEy98Dht6O/6yCZXHeepuJxTEvSz0s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKnAnWHF;
	spf=pass (imf05.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774234449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jx23AGpC1KRCKLBNhmCjUz1NFVaJ2RrysRQP2TgzV8c=;
	b=FKnAnWHF7OHCOixDGOqDI8nSUCeqar8655WDC1DL9JJBudhRVtE4McZZlDbo/LjhfqRzM9
	XKFssmKonFk24m/+tYR9v2b0671GJs03rJZIWqWQfXxTB91dn5Behowb/qe2BVlb9r1BuG
	VeeGSGNUGclJunSiHqW7dJBrEt7aJic=
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com
 [74.125.82.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-Z0LE5fVrOjivfzfooLipww-1; Sun, 22 Mar 2026 22:54:05 -0400
X-MC-Unique: Z0LE5fVrOjivfzfooLipww-1
X-Mimecast-MFC-AGG-ID: Z0LE5fVrOjivfzfooLipww_1774234444
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2c0ffce2570so3146461eec.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774234444; x=1774839244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jx23AGpC1KRCKLBNhmCjUz1NFVaJ2RrysRQP2TgzV8c=;
        b=ONU2JFD5m9bzJZDNTDZhxhmQ/u0ecOVpUb7XaJrFDSkWuB08D2z3kCwAukHNu8wIG/
         zeZk3ThfNkNz0YZUOMGgJ+9is6poz06WUBx0FDy4j0b0ial/jYdnoh95y2eUATYPGEAS
         kVJjDHFGs6+6VhTdQyP1Ny/lIxj7iEqiOnXTpVgtGHnXK54KBbKT9C1AHYRukSEj8GAc
         bBfbImW45YEUe489zjbrrSC1rZSv8zeCRG8OxCzZr3felb9tXRen7MLGOIv4FKn+z2OJ
         yKBARVh1FbyY1/Q3nSn1PBa+MmnJ/thw6tBtrcPCExm6WU/RCwPDoaV/VXzPgqK4fPpa
         lm+g==
X-Forwarded-Encrypted: i=1; AJvYcCXNjAC3B43yyVpK4tq+xzQlr4Sj+0x1EEeNtG95NXSbuWyorb6X5qyV7WxjlRdg0GFAEQqOusXB9Q==@kvack.org
X-Gm-Message-State: AOJu0Yy/Xek1p4dZY7zoE1L9j82oJI5Y2R0Xi/SHGxmjiZEyfIpiSEmK
	mLLD5s3FhIebt18CxsYWO60PML7/z7MkYM1MS4KOmgK1RgiujqaKcl7CP6rag3P36z1LqI7jETH
	IoovpIF76Ts2LR4hLjGAQwQFUKpuuzIyePS4cRLRhZvHSb3+tsFauxBICtFeFlOpm2eO6eq5Z2+
	s5hofs+rkwMAetNkrRFigrj08B5W4=
X-Gm-Gg: ATEYQzwJ2QaOyn+ia4Z7ReWMXEQcnNVVhazcPTAsaWnyBvChD9CA98sc5Vd8bV80zlk
	GJm8Q3QnojJ8KmLmqHT7+7GFfJ35Tupx7B8Kz2JWlIhTlQ3PE3dLb6/nvWB4I0joxgngWfhGAFP
	2OdlB2+A6oBn+9WbErMrgrZMFiuUeFNoJTp5AcnIfTR+Pb/37RCl+DOmPNQDt2+eN+e8N6NPOEC
	t3rGIM=
X-Received: by 2002:a05:7300:e82b:b0:2be:6f6:a39f with SMTP id 5a478bee46e88-2c1097c0812mr5124727eec.26.1774234444173;
        Sun, 22 Mar 2026 19:54:04 -0700 (PDT)
X-Received: by 2002:a05:7300:e82b:b0:2be:6f6:a39f with SMTP id
 5a478bee46e88-2c1097c0812mr5124711eec.26.1774234443719; Sun, 22 Mar 2026
 19:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260320204241.1613861-1-longman@redhat.com> <20260320204241.1613861-4-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-4-longman@redhat.com>
From: Li Wang <liwang@redhat.com>
Date: Mon, 23 Mar 2026 10:53:52 +0800
X-Gm-Features: AQROBzDsoohYs_nQGewOM6M1wB6UVv5EDlbiSkpHdgL9MlsBWxM2G4Le8YWcy98
Message-ID: <CAEemH2cJeTWLCLnmHqQY+tAs8b8FM+AmQ3UYd8McM760cN_Atw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] selftests: memcg: Iterate pages based on the
 actual page size
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6zkekhFBQ1Bbs5iI636Sz-wXmwJmLFNoe2Djsru-HY0_1774234444
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="000000000000c43dc5064da825dd"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97F8710000C
X-Stat-Signature: uhz56qkppditb6fgojdtxp64hg46en4w
X-Rspam-User: 
X-HE-Tag: 1774234449-425806
X-HE-Meta: U2FsdGVkX1/qkL/5zVFz3Ayqbv12leOBYWPUa4ieNP8iIo+rtt4G73W/LJkWM9c9/wY0QFFabjZARacQpLfrkjrF6TduIF6bWImHYdEmvstiUHP33K/1MmTvNOevZD/7FW2v/jcGcYawKOHB+OcZ8zKd0CabITAGjjbv0k/ac1BTYlSBCtiMOFHVU0QBaGUqP89/jlxQ7zyLaoDlODmvmObt3fUVK8zMJ2jcGOmU5YdXAZlr61s3VMwsOaBTcKE9Hbk+3o7cOaR92xNQ+el1GNFrY444jVqdvgygJV8UK7ANX3jE1oswHmHj1PxlEZjXB1TW2MiZGWCOGSYz0fTXNnHBqMrY4oN3oJEQ4k2ekfjAu9PCUtWRTcrXPwiA/JlfMYrxcJJqits1gGsKi+ko/uBREW3/Tw6QGLFc8tSDU/Pzr2PiIR/elLyFhEamZpw6s/FB+vBqBV8lPgr2FHJMKVYuPzL0RAIC3+zW6S5x1mkgcjLePjKU9CLldrar9U5NkNu+YEvK7hEhxK1Wqy7u0DtCDtY/p7r4IM5Ojvnx4VQM67t0161zh81fT7480Kr40z1QQQgnAufbqOC+j768YhpZX6KsmuamhG+ptDcCBP975W1SQaue2JcVmCsxZjAHbs9foLpj+5LXNxbMjcFAIhznVaTdEDypono++KHitnDZGXmbZ1FmH3o+TjXXiI+NuJl7v7Cp4u07A4hzqSQgePjPy9uxym96O4rZ0bRBoPMNBbYe4zePiiZDrYaPpSjOLj6YCcYzCH48uh0R08ZsTqwPU/fTrgj4NSzpbKxXzT+lfhKik0j3bUDhl7kj9g9OUL8pXWA1ahOab1otYUWk8xHLnpniS5lGpM5txgOTH4MVsAHgJ3L8N+7AWReWDxG+UhXG4HrR8oDZfrKjkkzRyU+e1dHRP28NDmU1tyW0BaIAR1jhdlgvuiFBQ7mlYL/9PfX6LA0/DsktUN5we0q
 pBCHon7M
 gyep0YUdRyHzViU0D7qvJEMxLqAFweMlxe+wVOqM5EuVqWzNSTlwrVT0+lQXHi+8F3PnSYC4ftSDcY8SRvPQn1eAyAqx9aOW04m+ct5gOzBBfzA46KBN4S/QwfhUsvrQyUuqyrssMLVwW5YDLVBorq1tDUDH9dHf7tu/1+Y9L/nTewhiBJ8+SZ01eIwQscoeMionWQHByddkHntuDubvPhlC6pcpI+CqMjw2PlnL88GQXHIqrwzsdGu5pZX20pDI6rEoM5nhNeuJuSpSa3+f03ga8FJvLJC4RL3xbOlm5tXh723DnaVSh3UTIVQm70sLRDlWLFZhjKarqz6taYJfuyXqjJx+UGiPEG+xu2djrp02zo0NxvTqpyTGXL5ZgSBzB9c1ab5V8c9AzSjaxitqU9hamRUePdYfLo7BZRX6JXBgAgRAuZsHrktow7yqdrwg1Gng5BK2RmTIh9FmJDqXG2Fs7RovCgr3zXbJZbdaemjekDxwD1gpNj8i2jQamE5HmNp/7O362/uyfqSUyf/yu2Lnps8ra0EOACvVryE3fRZ6tesapOgCezG0YQNsvq6sIKICYKymhwFyFQEtvgplXnYGaPezCNyaKmhwumbrALLDTskA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c43dc5064da825dd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Waiman,

I currently have another patch in hand that is functionally identical to
patch 3/7 here (requested by Sashiko).

May I go ahead and merge it directly into my patch series, while
retaining your authorship attribution?

Otherwise, our respective patches will conflict when merged into the
mm-tree.

See:
https://sashiko.dev/#/patchset/20260322061038.156146-1-liwang@redhat.com


On Sat, Mar 21, 2026 at 4:43=E2=80=AFAM Waiman Long <longman@redhat.com> wr=
ote:

> The current test_memcontrol test fault in memory by write a value
> to the start of a page based on the default value of 4k page size.
> Micro-optimize it by using the actual system page size to do the
> iteration.
>
> Reviewed-by: Li Wang <liwang@redhat.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c
> b/tools/testing/selftests/cgroup/test_memcontrol.c
> index a25eb097b31c..babbfad10aaf 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -25,6 +25,7 @@
>
>  static bool has_localevents;
>  static bool has_recursiveprot;
> +static int page_size;
>
>  int get_temp_fd(void)
>  {
> @@ -60,7 +61,7 @@ int alloc_anon(const char *cgroup, void *arg)
>         char *buf, *ptr;
>
>         buf =3D malloc(size);
> -       for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
> +       for (ptr =3D buf; ptr < buf + size; ptr +=3D page_size)
>                 *ptr =3D 0;
>
>         free(buf);
> @@ -183,7 +184,7 @@ static int alloc_anon_50M_check(const char *cgroup,
> void *arg)
>                 return -1;
>         }
>
> -       for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
> +       for (ptr =3D buf; ptr < buf + size; ptr +=3D page_size)
>                 *ptr =3D 0;
>
>         current =3D cg_read_long(cgroup, "memory.current");
> @@ -413,7 +414,7 @@ static int alloc_anon_noexit(const char *cgroup, void
> *arg)
>                 return -1;
>         }
>
> -       for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
> +       for (ptr =3D buf; ptr < buf + size; ptr +=3D page_size)
>                 *ptr =3D 0;
>
>         while (getppid() =3D=3D ppid)
> @@ -999,7 +1000,7 @@ static int alloc_anon_50M_check_swap(const char
> *cgroup, void *arg)
>                 return -1;
>         }
>
> -       for (ptr =3D buf; ptr < buf + size; ptr +=3D PAGE_SIZE)
> +       for (ptr =3D buf; ptr < buf + size; ptr +=3D page_size)
>                 *ptr =3D 0;
>
>         mem_current =3D cg_read_long(cgroup, "memory.current");
> @@ -1679,6 +1680,10 @@ int main(int argc, char **argv)
>         char root[PATH_MAX];
>         int i, proc_status;
>
> +       page_size =3D sysconf(_SC_PAGE_SIZE);
> +       if (page_size <=3D 0)
> +               page_size =3D PAGE_SIZE;
> +
>         ksft_print_header();
>         ksft_set_plan(ARRAY_SIZE(tests));
>         if (cg_find_unified_root(root, sizeof(root), NULL))
> --
> 2.53.0
>
>

--=20
Regards,
Li Wang

--000000000000c43dc5064da825dd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_defa=
ult" style=3D"font-size:small">Hi Waiman,</div><div class=3D"gmail_default"=
 style=3D"font-size:small"><br></div><div class=3D"gmail_default" style=3D"=
font-size:small">I currently have another patch in hand that is functionall=
y identical to</div><div class=3D"gmail_default" style=3D"font-size:small">=
patch 3/7 here (requested by Sashiko).=C2=A0</div><div class=3D"gmail_defau=
lt" style=3D"font-size:small"><br></div><div class=3D"gmail_default" style=
=3D"font-size:small">May I go ahead and merge it directly into my patch ser=
ies, while</div><div class=3D"gmail_default" style=3D"font-size:small">reta=
ining your authorship attribution?</div><div class=3D"gmail_default" style=
=3D"font-size:small"><br>Otherwise, our respective patches will conflict wh=
en merged into the mm-tree.</div><div class=3D"gmail_default" style=3D"font=
-size:small"><br></div><div class=3D"gmail_default" style=3D"font-size:smal=
l">See:=C2=A0<a href=3D"https://sashiko.dev/#/patchset/20260322061038.15614=
6-1-liwang@redhat.com">https://sashiko.dev/#/patchset/20260322061038.156146=
-1-liwang@redhat.com</a></div></div><div dir=3D"ltr"><br></div><br><div cla=
ss=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Sat, Mar 21, 20=
26 at 4:43=E2=80=AFAM Waiman Long &lt;<a href=3D"mailto:longman@redhat.com"=
 target=3D"_blank">longman@redhat.com</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">The current test_memcontrol test fault=
 in memory by write a value<br>
to the start of a page based on the default value of 4k page size.<br>
Micro-optimize it by using the actual system page size to do the<br>
iteration.<br>
<br>
Reviewed-by: Li Wang &lt;<a href=3D"mailto:liwang@redhat.com" target=3D"_bl=
ank">liwang@redhat.com</a>&gt;<br>
Signed-off-by: Waiman Long &lt;<a href=3D"mailto:longman@redhat.com" target=
=3D"_blank">longman@redhat.com</a>&gt;<br>
---<br>
=C2=A0tools/testing/selftests/cgroup/test_memcontrol.c | 13 +++++++++----<b=
r>
=C2=A01 file changed, 9 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testi=
ng/selftests/cgroup/test_memcontrol.c<br>
index a25eb097b31c..babbfad10aaf 100644<br>
--- a/tools/testing/selftests/cgroup/test_memcontrol.c<br>
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c<br>
@@ -25,6 +25,7 @@<br>
<br>
=C2=A0static bool has_localevents;<br>
=C2=A0static bool has_recursiveprot;<br>
+static int page_size;<br>
<br>
=C2=A0int get_temp_fd(void)<br>
=C2=A0{<br>
@@ -60,7 +61,7 @@ int alloc_anon(const char *cgroup, void *arg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *buf, *ptr;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 buf =3D malloc(size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 PAGE_SIZE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 page_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ptr =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free(buf);<br>
@@ -183,7 +184,7 @@ static int alloc_anon_50M_check(const char *cgroup, voi=
d *arg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 PAGE_SIZE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 page_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ptr =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 current =3D cg_read_long(cgroup, &quot;memory.c=
urrent&quot;);<br>
@@ -413,7 +414,7 @@ static int alloc_anon_noexit(const char *cgroup, void *=
arg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 PAGE_SIZE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 page_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ptr =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (getppid() =3D=3D ppid)<br>
@@ -999,7 +1000,7 @@ static int alloc_anon_50M_check_swap(const char *cgrou=
p, void *arg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 PAGE_SIZE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (ptr =3D buf; ptr &lt; buf + size; ptr +=3D=
 page_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ptr =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mem_current =3D cg_read_long(cgroup, &quot;memo=
ry.current&quot;);<br>
@@ -1679,6 +1680,10 @@ int main(int argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char root[PATH_MAX];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, proc_status;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0page_size =3D sysconf(_SC_PAGE_SIZE);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (page_size &lt;=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0page_size =3D PAGE_=
SIZE;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ksft_print_header();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ksft_set_plan(ARRAY_SIZE(tests));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_find_unified_root(root, sizeof(root), NU=
LL))<br>
-- <br>
2.53.0<br>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr"><div>Regards,<br></div><div>Li Wang</div></div><=
/div></div>
</div>

--000000000000c43dc5064da825dd--


