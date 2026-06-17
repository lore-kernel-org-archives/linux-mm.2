Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B39CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49716B009D; Wed, 17 Jun 2026 08:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21ED6B009E; Wed, 17 Jun 2026 08:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38166B009F; Wed, 17 Jun 2026 08:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B816B009D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:26:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF7840453
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:50 +0000 (UTC)
X-FDA: 84889328580.02.9701DF0
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F9891A0009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:26:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CKQmHXei;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1QUUKaLC/Yp6GNmwaJDa63gpktICnRgKXbMRmfaFDY=;
	b=PjUTJ7pmavBPMQhDl6IB5c0VxBHmAucc/N3+1OqYjI5ugpPFoxFfWS2HcVefO7KNV5JOCM
	mvbFXwqpdxZMMb/bUWJzgopu9m7BA6OTsl9G5bhHvQfTi+UOJlFadjivQmq2Mm0wq44Lh7
	ppGLap2+Il066jOrX/GQ/vEcSn1Lvtg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CKQmHXei;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699208;
	b=rhbTe5G5B817FOjXfFR90/Axcr1geNvmtg/cZCRYjyIQRJSXb+y/8Vu4hBZOpXHA760agj
	Mg3rD363/KP+3BnVpg5InbxzXShImfzcJUcKhdsubyn1VetarCbXJv8q1sd9fvqNsZ/A4y
	NN1c/aSDaMPh56Ui5UDVF55cYaoWkd0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so7369805e9.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699207; x=1782304007; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F1QUUKaLC/Yp6GNmwaJDa63gpktICnRgKXbMRmfaFDY=;
        b=CKQmHXei73EUSopyiuflNkPLDU/2k4vq6/6ArtNzrf+OfiMOM33czK6/keh77oWq8S
         6hfR3LObVTzNBKD/WcNzz5ZiualCc1ZIfgFPHd7oxDX/HL/PWEN9VjJaUnsZD7fKN5Lo
         +RtQI1PZ0xulgHOurn2Bfct9l2dwF81BNv/zXzAwxBBDWuk+8G4/X36jdJS6JNEoxiT8
         RgFb57opceCST1cryHCbrmSnvJhEsc4rpQ5SlOlWYh9b/J5apeBqj1rJ1/iDloICvBNa
         NlwUoaS9T3VLh071YWLi0a4bR44892eZheYvuAAt/VU8uEiNARAkAu7EBrqHsESj9Jkk
         +Aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699207; x=1782304007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1QUUKaLC/Yp6GNmwaJDa63gpktICnRgKXbMRmfaFDY=;
        b=WOZwAk4jf/CTTcSPwtvPF2E1gcqafkxAUgXC15az6+2SKFggLZ8+LTV6+4nQTRTfC4
         JTIlFWGyiOaI80EdyiTv4XijJkpttw3iF9Sjckv3+SYQP3IxnmctHxOkOeX/ZIjrDSvH
         R1THzgEGTvnigPo737EchHEVXS9wMfcqj4MuZN2/b+9E96jppr2UsvhPaKPcEuKcw3Zi
         kujxsgsXeOMCe/ukLfY+a+2DssKm8UM+PjVvGcmuHqJdW5lT9IKEQIT0X06tGTQqLwws
         0YMF7k8oBHB2GxDlV6kema4NPU4sB/MxZF+DPac47+X5X90CdxjVnktjkBEbyabcgg2a
         Cxlw==
X-Forwarded-Encrypted: i=1; AFNElJ8y/0w05cMCN0GCDwhrVC5G7q6BTOse/OhAwswCutnQ5S13cepQarY9qzGMFxmi/B23fg+X4lQROg==@kvack.org
X-Gm-Message-State: AOJu0YyiAc1ZOPEJPp1DVwaJEtrsBNvyi4hznyRmtRXaNPNz8MxvgWqZ
	jU85WR/Z9/yc5O5Sofu1rFuLxxyXERODvCtMqgCG2rmMMuGp+B2XnTWPHXsGOosfV1o=
X-Gm-Gg: Acq92OFnaXHTY4U64w8/omuuBjJOd8jGtt2XIh3A+BqxcqDPls/Bf2hSVIycj6947EZ
	RQ4vTayJIBwF6fPnILVzPet10MCwbUp4/ur6Ei+ksjsLBkgPXq0cG1h6Nla/MkJOTsHLVqYAGba
	gxAcj1DCrTwqUejATkZzCs8ZuKAVdn1kp3eMaOsuipYwivSvJDGdvA8iiqQ4WrvgKrCmXDYabDS
	D0qUiU4sxH02wSN6k4lfeYEucs63PZgO1+1YlEW8CR1D17ET3Sj88hdTFFWnsUdo7Yo+mb3lkWR
	294UP+np+0bXlfieSgX+jghqFyKZFcI2Xyi77Xzn944NJRGBd7bsD0uDLDlODn4UpPoI1vwoZg4
	PQN7AmDk1X+kSsJF91seomsLCUcZNfRGX6ctAgsFaPLkXcNS7aM6/m+2M9vLhP/cZE2+QoFTSds
	uOW673T3netZoTZRLLXw==
X-Received: by 2002:a05:600c:8285:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-492357da8b7mr20835875e9.11.1781699206568;
        Wed, 17 Jun 2026 05:26:46 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a8ec56sm139769275e9.9.2026.06.17.05.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:26:45 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:26:43 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 4/8] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in
 cgroup_util
Message-ID: <ajKCNAocU_BXxymR@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-5-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pntlo5ut2wdod2v4"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-5-li.wang@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0F9891A0009
X-Stat-Signature: duy5agjxyxhbb35qbh71xdznxuahfz8j
X-Rspam-User: 
X-HE-Tag: 1781699207-232797
X-HE-Meta: U2FsdGVkX1/tMgxM2B2Aku7ybxGdwELF+ejwVzn+OuxwRMwtl1hFii0HEonWQSlZKkDHCWSBZTggw7dFkFDRZFCpNRK3omH2qiC9t4MBBwPQ7mgvHKPvUIUXCBUI9P5/tiD5soqr7gxO0pKM7o7RZjUqCNNRua/YTW8kduDO8D8RMWmJdQKNU7YiNWNFhg7emZ0u32yjqqQLk+htKcLDiMs7R4HTtmUej2ITyWCUvVfYdaSLTboWP60MITTNd9v3mkhEEnS/8F/AdaN8mNdTlswfxVEqmjEpIdpQa4fNLt35n1WhR+qOphZZbvn+hF6p1Eo3C3cM2mjiWbVVB1kYZan0apIuTbkJySgCtzYeNOkLidqWH9rXolBeyeGXHoQjEfRbTJ5BojWldVn2XXj32BcwPeYBeGdCr2HADGSYVqutT9SUkEgKqMSi149HbpJSzsyO09NK4aIRgu271Zt94+yTHFCHp0O8oZoq0ZhnuX4nKsebPhGenbJz74miH1XorD2xHdLKRHppqqLJqD7y8J34FA5v58M+KHqeYPxfoLZEB1iu9pKaqmCSxbA2uDFqENp8QQorNSN8S6sIWZzJ0V0mxYy2V/U3cCSFc/Yzdt+HJwA7c7otwxVHs/3j3Dk08r4F4CQAi7cgIjM1oq8LEfuNsFpu6lD+FzA/lXuAksHOyxpDfKRJo2sZq+kQW8f8mQJMK6BJlVilHd8xYQY/39l+g+YxD5CRNlFDT3AevAXrUZx2IfwGBMvdYDkmoh9Ef0r5L5EPkXsMJ3fDHJWHzfI9jh2BW9w9sD2qkRdAUkLB5REwc1uB3Cp84xXCzXJPtqLUfRsJ/LkM5OPYCCKIMfrLuKbfe8qPJZ1QjLCDl56ToR8hJluyi68DoWFuOA9k9TwUfguMTI4BBUuVSgEda+4BaCnJYqSeOmFwGI3jgAkFeYED28RyS+S1yrTVkypsaLGo1GKuB+kp9qOARZ5
 bL/L47h6
 wvB/NgxMjB+JTXGtYF/TgWYfJLOCA3cj7UaDPO/pGKtdjewVCi6DFR41eHC92C9Ena/aHjdT5PE52Z8ofPz6cCMz8Vp5wzPHdUhWfXHGyvoSA/LLUacG4q2XATXQQWsUKuhkjlrMqRjSHMaSR6F56kLVIC/MDdlc+f3A3iu8fIZVOvLc0yiX3ui5NarcEqDN7Z51HFxOehKNU56BujEap+Y2k8sLemnWT/d0of6CvYv46pOwQgtFCAOfQPrkA6XRyNInhomcSPluZaJ7meuPwHNfpr3qYVH3k9iN4maBO13/3o8qaGFlHub+g34ScIZQMVDXjDshQqY1cP1zWCrTj2jShVANe8gzgk1WWgtZFclWp4uwg99D/UFsNbx18WunwdtH0vvQoO/q0wWBPA4EqLmrG4kTV9loz7u9YbdG4o5Z/MO+DPD+D3iQ3J/H+5ydP8Bg5ta2X/0DxsdXPDsLhHjUkdL11gFyweABOVnYjxRe/Ocfa83lOvvZ2qDpCR9NSYD652UW+130ovS7hG/G1ElscovexTSgh9xmzG20GKkZXL4U0XdhaM8D5U/pQYj3bWtcqG/TzETwy4UKbC358Fjd6zNCbVpAkeU4dcxZcfUB2/axA92lB0tdpKHY3bGsvx0Hxcq1TLB6FXQ9yrXgvZ9kG+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pntlo5ut2wdod2v4
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 4/8] selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in
 cgroup_util
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:55PM +0800, Li Wang <li.wang@linux.dev> wrote:
> The cgroup utility code defines a local PAGE_SIZE macro hardcoded to
> 4096, which is used primarily as a generic buffer size for reading cgroup
> and proc files. This naming is misleading because the value has nothing
> to do with the actual page size of the system. On architectures with larg=
er
> pages (e.g., 64K on arm64 or ppc64), the name suggests a relationship that
> does not exist. Additionally, the name can shadow or conflict with PAGE_S=
IZE
> definitions from system headers, leading to confusion or subtle bugs.
>=20
> To resolve this, rename the macro to BUF_SIZE to accurately reflect its
> purpose as a general I/O buffer size.
>=20
> Furthermore, test_memcontrol currently relies on this hardcoded 4K value
> to stride through memory and trigger page faults. Update this logic to
> use the actual system page size dynamically. This micro-optimizes the
> memory faulting process by ensuring it iterates correctly and efficiently
> based on the underlying architecture's true page size. (This part from Wa=
iman)
>=20
> Signed-off-by: Li Wang <li.wang@linux.dev>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=FD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  .../selftests/cgroup/lib/cgroup_util.c        | 18 +++++++++---------
>  .../cgroup/lib/include/cgroup_util.h          |  4 ++--
>  tools/testing/selftests/cgroup/test_core.c    |  2 +-
>  tools/testing/selftests/cgroup/test_freezer.c |  2 +-
>  .../selftests/cgroup/test_memcontrol.c        | 19 ++++++++++++-------
>  5 files changed, 25 insertions(+), 20 deletions(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/tes=
ting/selftests/cgroup/lib/cgroup_util.c
> index 6a7295347e9..9be8ac25657 100644
> --- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> @@ -140,7 +140,7 @@ int cg_read_strcmp_wait(const char *cgroup, const cha=
r *control,
> =20
>  int cg_read_strstr(const char *cgroup, const char *control, const char *=
needle)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
> =20
>  	if (cg_read(cgroup, control, buf, sizeof(buf)))
>  		return -1;
> @@ -170,7 +170,7 @@ long cg_read_long_fd(int fd)
> =20
>  long cg_read_key_long(const char *cgroup, const char *control, const cha=
r *key)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
>  	char *ptr;
> =20
>  	if (cg_read(cgroup, control, buf, sizeof(buf)))
> @@ -206,7 +206,7 @@ long cg_read_key_long_poll(const char *cgroup, const =
char *control,
> =20
>  long cg_read_lc(const char *cgroup, const char *control)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
>  	const char delim[] =3D "\n";
>  	char *line;
>  	long cnt =3D 0;
> @@ -258,7 +258,7 @@ int cg_write_numeric(const char *cgroup, const char *=
control, long value)
>  static int cg_find_root(char *root, size_t len, const char *controller,
>  			bool *nsdelegate)
>  {
> -	char buf[10 * PAGE_SIZE];
> +	char buf[10 * BUF_SIZE];
>  	char *fs, *mount, *type, *options;
>  	const char delim[] =3D "\n\t ";
> =20
> @@ -313,7 +313,7 @@ int cg_create(const char *cgroup)
> =20
>  int cg_wait_for_proc_count(const char *cgroup, int count)
>  {
> -	char buf[10 * PAGE_SIZE] =3D {0};
> +	char buf[10 * BUF_SIZE] =3D {0};
>  	int attempts;
>  	char *ptr;
> =20
> @@ -338,7 +338,7 @@ int cg_wait_for_proc_count(const char *cgroup, int co=
unt)
> =20
>  int cg_killall(const char *cgroup)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
>  	char *ptr =3D buf;
> =20
>  	/* If cgroup.kill exists use it. */
> @@ -548,7 +548,7 @@ int cg_run_nowait(const char *cgroup,
> =20
>  int proc_mount_contains(const char *option)
>  {
> -	char buf[4 * PAGE_SIZE];
> +	char buf[4 * BUF_SIZE];
>  	ssize_t read;
> =20
>  	read =3D read_text("/proc/mounts", buf, sizeof(buf));
> @@ -560,7 +560,7 @@ int proc_mount_contains(const char *option)
> =20
>  int cgroup_feature(const char *feature)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
>  	ssize_t read;
> =20
>  	read =3D read_text("/sys/kernel/cgroup/features", buf, sizeof(buf));
> @@ -587,7 +587,7 @@ ssize_t proc_read_text(int pid, bool thread, const ch=
ar *item, char *buf, size_t
> =20
>  int proc_read_strstr(int pid, bool thread, const char *item, const char =
*needle)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
> =20
>  	if (proc_read_text(pid, thread, item, buf, sizeof(buf)) < 0)
>  		return -1;
> diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/t=
ools/testing/selftests/cgroup/lib/include/cgroup_util.h
> index 567b1082974..febc1723d09 100644
> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> @@ -2,8 +2,8 @@
>  #include <stdbool.h>
>  #include <stdlib.h>
> =20
> -#ifndef PAGE_SIZE
> -#define PAGE_SIZE 4096
> +#ifndef BUF_SIZE
> +#define BUF_SIZE 4096
>  #endif

I wouldn't preserve any previously defined BUF_SIZE here (as opposed to
possible more conventional PAGE_SIZE value).
I.e.

-#ifndef PAGE_SIZE
-#define PAGE_SIZE 4096
-#endif
+#define BUF_SIZE 4096

But it's nothing substantial.

> =20
>  #define MB(x) (x << 20)
> diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/s=
elftests/cgroup/test_core.c
> index 7b83c7e7c9d..88ca832d4fc 100644
> --- a/tools/testing/selftests/cgroup/test_core.c
> +++ b/tools/testing/selftests/cgroup/test_core.c
> @@ -87,7 +87,7 @@ static int test_cgcore_destroy(const char *root)
>  	int ret =3D KSFT_FAIL;
>  	char *cg_test =3D NULL;
>  	int child_pid;
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
> =20
>  	cg_test =3D cg_name(root, "cg_test");
> =20
> diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testin=
g/selftests/cgroup/test_freezer.c
> index 97fae92c838..160a9e6ad27 100644
> --- a/tools/testing/selftests/cgroup/test_freezer.c
> +++ b/tools/testing/selftests/cgroup/test_freezer.c
> @@ -642,7 +642,7 @@ static int test_cgfreezer_ptrace(const char *root)
>   */
>  static int proc_check_stopped(int pid)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];
>  	int len;
> =20
>  	len =3D proc_read_text(pid, 0, "stat", buf, sizeof(buf));
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index b43da9bc20c..44338dbaee8 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -26,6 +26,7 @@
> =20
>  static bool has_localevents;
>  static bool has_recursiveprot;
> +static int page_size;
> =20
>  int get_temp_fd(void)
>  {
> @@ -34,7 +35,7 @@ int get_temp_fd(void)
> =20
>  int alloc_pagecache(int fd, size_t size)
>  {
> -	char buf[PAGE_SIZE];
> +	char buf[BUF_SIZE];

This buffer is actually used as the stride, so keeping it page-sized is
more sensible.

>  	struct stat st;
>  	int i;
> =20

--pntlo5ut2wdod2v4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSfxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhHwgEAkX4FwWHul4xsY8MctUcV
Vl/flepLLEiM/EKitqQPxNsBAJuVp8BQeVZpJQ29pFjdnPKSxvEJmQhD3mGHwEUf
A18N
=yJJi
-----END PGP SIGNATURE-----

--pntlo5ut2wdod2v4--

