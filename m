Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F8BCCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 05:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB4F6B0088; Sun, 18 Oct 2026 01:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C616B008C; Sun, 18 Oct 2026 01:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23AD6B0092; Sun, 18 Oct 2026 01:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C09B6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:03:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FDFEA041F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 05:03:30 +0000 (UTC)
X-FDA: 85334553780.28.7ED6B66
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 372141C0008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 05:03:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M3WlSgPL;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792299808;
	b=MlVhFhHfCEnxp4Y3V4q0UbhiwX30w7C2ZYheMTqhPqFWN4xMSwoD3C6lBQw11ZEoXhPlI4
	3DXhbfZwmcxIx8H6B4idwtPnACCbUKL5lkNo306sxFQ0cvUuEXEMJGOvasKairzFW/CwY0
	3YY72GOYdFABG7rWGB2OMPSlnxVcAdI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M3WlSgPL;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792299808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJriBqGLviqWmHHPERdjBK4yfnHo9QPRMrJXUUU8Ae8=;
	b=aXeF8eT0Z5znIZne6VgSNL0Du+BBVgR9hQGagfpcKCXKVnMZ7wkfPWZ4ACJaSqwfuO0awG
	8UF0OhpYUMkPDrvTE9F5yusFH/eBvvaAfax2IpU+qLiqs8vmpXeEoHnu1+7WGkf5MY+o3Y
	n5iEnFwGQ/X4VdRZ3NflDtUoPq8BybE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535f598d126so154581cf.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792299807; cv=none;
        d=google.com; s=arc-20260327;
        b=IyX+k1f+UTi8DSxPukKghVMPeRuZAa8dnGYKiD0ePVY60NJgB3t+AHMJUQVP/Yrnfe
         ktm61BQiJ9cdOBcX3cN1s7jbC+GGz5Y4ohhfm5SxcdEzTZU4ZOA1/ipgzUAlkjZ53DAY
         GcmmNUeKUxdJxt0mRHgTOqkuv0bEcZxFpqg7Wb1emV0dXwTbCl4duSiXmgqSo1OuS8bV
         7mrhGrSzIe+zUv+5laCyT8W58Hg0Yt6vxejEU8qVPbNqmk+gRkM3nuTWVw1YOQm10c9h
         lpmnzW519fYy5STz8MBMo5/SzVFD9Ub4a3k5t0iToKXuueZpdlHse+mhKKx0FjbAVQ9I
         qKSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJriBqGLviqWmHHPERdjBK4yfnHo9QPRMrJXUUU8Ae8=;
        fh=0ejgjNW6JJ3Ax3dR9I+MLdK9JEuD/G+osQVkxx2qP2U=;
        b=RPGHoRCFm1k1u8+46zi2wHm2cGsB/+cbT43Z2Sqw4CEJGmOUIu8X5dLOjw1DoTPIO0
         87haneKonKTQ+3OhWr6JEEVMikXlAVga0xH4YeCV7WiPPnT0tJuhrtPi2XKRXrJmAWtu
         5wmaU82YzBGG3e6dUaI/wW0PZjKhWOvh/z0U5ZQnrkuVxWdy9YBbDPfypfSTpqHoeXo3
         moerbDWrIDj6n1ey7I3+gRHRGI2/K7ktxTNhxJLbM/alokaRozgteh2QO2WnWf/k7CUV
         O6JtvkgE1PcoPTMIyscF4CiM4qy2f0io/26Tmnwlthw6BJ4Qoe2V6ASXl4/dzAwOPV+l
         mKjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792299807; x=1792904607; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WJriBqGLviqWmHHPERdjBK4yfnHo9QPRMrJXUUU8Ae8=;
        b=M3WlSgPLuLp7sZ1pVjgRw/XKqPjKPq6KSPHp8UNieQkN5jgK4pHYDPsbcTTKtqh5Pa
         dXRkfaztspRZiMeGeUINAvLO/2EEmdmjj/J6QiGLJjZokxeDbfwJOani6HxpG2yTS82u
         rZ/71oOgH9XTxiPBTQ+geGqv4ocZrjOJ0NdFokAxu7xNdqq2LvL4V/kawVWcusDNGDGq
         ZkeTCziXNtkq6jCJ4TeYi7kpRiiX2ZfEa++dAkr1Cq64SyTQTw5tt/7TBLlor30smhQP
         kFvS7VR1eyWEZKLSzIXoxuL47OW+JhnJy6K/yu5bGfY4zLqQRiEeCt2dkH4EMEbMVQ+2
         OLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792299807; x=1792904607;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJriBqGLviqWmHHPERdjBK4yfnHo9QPRMrJXUUU8Ae8=;
        b=sEnAAweFvM3Wh+MzgDkCttkjT8f7P0JIwWWxqx5aEMMWjKXagzQVsfhMclI9EbMV2c
         FYyVz9ExztmZ0Dl/Of/E+cUNTcwHmS5dKdGLjGszTRfOpMB+fU/kqlntJ9FUNTM3xOVz
         /mk62qBpNkwzTrcR4MGI1D23bSxTNXOIAayCEVhzE3oH9PYSnXvACo+xaUyVUqcnNujF
         GlL+Dh1KSEgd8LCBHz4vpS3Z6WlhJESIdJl75VK/3Dib8AlsW5yZTY0q/YHHOtOcqdkQ
         EOeOa3Q7bibGWZncoUkVNKNXV85CimTjtUhojtkwO6vKgWb6M8sjOz2bK4x5WQF+sd5T
         f5yQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7RdlKpnUOSUfxzGt4uC1cA1kk5Ir26nOORLmoYR9Tkop/cqfrPXUFg+yJv8owhBlrLSEM44ZbYg==@kvack.org
X-Gm-Message-State: AFq9FYKIBg+vl+6xZHsxkLwzK/+XQDNB+JzIjBR5NfZHYpwgNIJ7o47G
	qeOd+hwS/5ezZ0/hf/wAFS6TxhvApyFnx8NSUw+zsCr8AhqNTk5uqxgUAXCowizWITKlMh+NLik
	wAJK6JlHCGatYfZDNEdXGNkB0PfXPNnG4WNziAhWm
X-Gm-Gg: AYBFou1hEew5XWQPEFUD3p9HxutC58ec8YShr//d3piQjwDpsjwHMBOadDpCYjIBOmP
	Kkmj9YtKBOWL79Bqa8AA4c3TGQIb5MQZ+JIcB/ki5EiI4I0gHX4dSWIik/YWhR/Tmrn/Hq+bvxI
	V432fqAuKeOcVOkO2HznuWRWEpKsLN2h6r/qIIHFWjO9EGJiIGEOAciFoF6ZvYnCZ5Kr5XhvVnG
	p4KuVK12EGUoyXzW7tm/GqrZTFakRiBGtS5foFlZApQa/D2dNry8t+06BiZLXuXAzSDSihozDUc
	wAq86hxc+6U7TcdELV0tSZiBN+8n18mJc1QacO7iGkWcvYpqmUOhAZAVEyF5FIN1cP4H6gbzMz8
	X67BQdKYZU5/qOArSNEPN97Gs/9WUAjJ5P05XIx8=
X-Received: by 2002:a05:622a:15c2:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-53646271decmr20079161cf.9.1792299806552; Sat, 17 Oct 2026
 22:03:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com> <ed2e9cb670af7d013aaf6585aea551587647f070.1791410886.git.abhishekbapat@google.com>
In-Reply-To: <ed2e9cb670af7d013aaf6585aea551587647f070.1791410886.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 18 Oct 2026 09:03:14 +0400
X-Gm-Features: AclHuK_oDOaokU5jt01qhnnQcmoO0pUXkqXeV5gDjzXh3IzX5q3ZSZp6iLCM8BY
Message-ID: <CAJuCfpGHwan9YDjn_9-8EGKT-ZP=GNVPnfY8zvv5nw9GUK5qiA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] alloc_tag: Add a test for trace state toggle and filtering
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 372141C0008
X-Rspam-User: 
X-Stat-Signature: wx9r6b41ormoqfbckmpwugtf53afc3yx
X-HE-Tag: 1792299808-669219
X-HE-Meta: U2FsdGVkX18TngC5U5eexqilgQlXzWooIZqcVtrWZVq0njlDDKv1Pk3EUNJHBrh9hG3ned8ekRb2iovXkMyF3xQAX0yYJewur7lFs9dVbROR3mBn6JwsSV5mi1cEh2tZZEphnKEkh2HPKqfZTyw4GE0VlxHCe9R/JHFcJT8UFOk0vDKWtpFBySmtYHrjUfMrzuiPNOoMoHJ3ChXHjElk51bjtYs/PpAID6/pQ5Y9ibkbEL98+jrA2HeDS1PgzLzNWZBMRzNSu05C7fpwQ3z6QMYhaTszAvvN2sKeGTXS9OD20S+WMf9khpg0QxK5SzQxA4EjcAGWslpjMOnczaMwO7jHUH4EyvmxJEJa/yRj7Tru3287ME+dkGzLhGENB3x/EQoXrAb0HWU4Hoe4CMswHuUbLinxgJbjTea4rBAL0VOjxfO9Wo9oiNb+tr5OR/9FHvyK1nGAi2qSW148mOxM+Bf3dWQVBbjB22dCacsJeS/Nx6SWJ27gLhOQpP1AMm+8nWsFXR9WphNhEe18evwJmx6xWb462yzDBk6gpT1LWhtE4VmdruADEpmD8paEnhcwGBdw2ma4I7ib9U2MA7T9tw9iCatlFJZes09dm0pFBqZVAA/j/o29VRnOoA5tUVRsyudrKRcTl/c20awly2XEYNyQhPjCziqGfFCt3l0nRJYpyY6Jo5Pi+lbfvXNYmwQ6zHeiSwYAPsA/IsPGhfNg5LLxN2M6+j19wJlMde/VVwPKw3CPfM05gUGcycwjr79YFULGtVG1G3nxsXbBYdJr24UzE4s/H9Z5Rk8iEz/XNMJiJU4rZX9YadyDGc5BjDfDsoACq6LJhUdaDQSrpvqOgqDW94GDgcj+WxI4cb992YKOh1Wx6KiKZf2kBkCz3Cij1g2UgM+gG3o7VmJJORg7+TdMpjnH4++8a+I1O/csWkfWWpB/TOsqOGwc24orzdRJc0tTQijzE1sza/XkUtW
 AKoh9vrN
 X6r5dAxxb3YBpdVI/lBZwaplYGmMfzMcMf+TmcpoGpLr4BABBljAoog2kyGcxan4ZjiA9HzQf1I1wJX7AWjRQQFto3U64mOf5lOVTw2LeJcIFyb2QpSZDUd5y0tGDACVXSiu+4RTDzRnTJCqwGtHISquIwoKe8xkivJt+3bqZF+FF/da+Nmq+DomT86Wtsrxhexj5PVoZAD8DfKvaz0nRftCbwWLWYdXOSFL57oa36Wrzz1dk6CpLPCKj4XJp4hSsYLDKYZPLD/AVmXSrv6DWTzWdUFqRak+o7K9B2B2SEwe56ZhAVOKubUDPvoxH2GVt7UsrI+zp3ZK2x6V3KTnpTtmHUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 2:40=E2=80=AFAM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> Following the introduction of the ALLOCINFO_IOC_TOGGLE_TRACE IOCTL and
> ALLOCINFO_FILTER_MASK_TRACE_ON filters for selective memory allocation
> tracing, update the kselftests to validate this behaviour.
>
> Introduce `test_tracing_toggle_and_filter`, which validates the
> architecture by:
> 1. Dynamically flipping trace execution state for a designated allocation=
.
> 2. Query the same tag again, and check that the returned tag reports the
>    new state in its `trace_on` field.
> 3. Restore the tag's original trace state, also on failure, so the test
>    does not leave tracing changed on the system.
>
> The test uses `dup_mm()` function name with the function filter in the
> IOCTL to run the above steps. If the `dup_mm()` tag is not found, the
> test is skipped.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  .../alloc_tag/allocinfo_ioctl_test.c          | 113 +++++++++++++++++-
>  1 file changed, 110 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/t=
ools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 74fd64b2370c..eb52ca1a1dc4 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -48,6 +48,11 @@ static inline int __allocinfo_get_next(int dev_fd, str=
uct allocinfo_tag_data *pa
>         return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
>  }
>
> +static inline int __allocinfo_toggle_trace(int dev_fd, struct allocinfo_=
toggle_traces *params)
> +{
> +       return ioctl(dev_fd, ALLOCINFO_IOC_TOGGLE_TRACE, params);
> +}
> +
>  static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
>                         const struct allocinfo_tag_data *tag_data,
>                         bool match_bytes, bool match_calls, bool match_li=
neno,
> @@ -289,6 +294,8 @@ static int run_filter_test(const struct allocinfo_fil=
ter *filter)
>         return ret;
>  }
>
> +static const char *target_test_function =3D "dup_mm";
> +
>  static int test_filename_filter(void)
>  {
>         struct allocinfo_filter filter;
> @@ -304,11 +311,10 @@ static int test_filename_filter(void)
>  static int test_function_filter(void)
>  {
>         struct allocinfo_filter filter;
> -       const char *target_function =3D "dup_mm";
>
>         memset(&filter, 0, sizeof(filter));
>         filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> -       strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SI=
ZE);
> +       strncpy(filter.fields.function, target_test_function, ALLOCINFO_S=
TR_SIZE);
>
>         return run_filter_test(&filter);
>  }
> @@ -514,11 +520,106 @@ static int test_lineno_filter(void)
>         return ret;
>  }
>
> +static enum ioctl_ret toggle_trace(struct allocinfo_tag *target_tag,
> +                                  bool enable)
> +{
> +       int fd;
> +       struct allocinfo_toggle_traces toggle_params;
> +
> +       fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> +       if (fd < 0) {
> +               ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> +               return IOCTL_FAILURE;
> +       }
> +
> +       memset(&toggle_params, 0, sizeof(toggle_params));
> +       toggle_params.filter.mask =3D ALLOCINFO_FILTER_MASK_MODNAME | ALL=
OCINFO_FILTER_MASK_FUNCTION |
> +                                   ALLOCINFO_FILTER_MASK_FILENAME | ALLO=
CINFO_FILTER_MASK_LINENO;
> +       toggle_params.filter.fields =3D *target_tag;
> +       toggle_params.enable =3D enable;
> +
> +       if (__allocinfo_toggle_trace(fd, &toggle_params)) {
> +               close(fd);
> +               return IOCTL_FAILURE;
> +       }
> +
> +       close(fd);
> +       return IOCTL_SUCCESS;
> +}
> +
> +static int test_tracing_toggle_and_filter(void)
> +{
> +       struct allocinfo_filter filter =3D { 0 };
> +       enum ioctl_ret ioctl_status;
> +       int ret =3D KSFT_PASS;
> +       bool initial_state, target_state;
> +       struct allocinfo_tag target_tag;
> +       struct allocinfo_tag_data_vec *tags =3D calloc(1, sizeof(*tags));
> +
> +       if (!tags) {
> +               ksft_print_msg("Memory allocation failed.\n");
> +               return KSFT_FAIL;
> +       }
> +
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> +       strncpy(filter.fields.function, target_test_function, ALLOCINFO_S=
TR_SIZE);
> +
> +       ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, 0);
> +       if (ioctl_status !=3D IOCTL_SUCCESS || tags->count =3D=3D 0) {
> +               ksft_print_msg("Could not retrieve IOCTL entries for %s\n=
", target_test_function);
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +
> +       target_tag =3D tags->tag[0].tag;
> +       initial_state =3D tags->tag[0].counter.trace_on;
> +       target_state =3D !initial_state;
> +
> +       ioctl_status =3D toggle_trace(&target_tag, target_state);
> +       if (ioctl_status !=3D IOCTL_SUCCESS) {
> +               ksft_print_msg("Failed to toggle tracing\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_TRACE_ON;
> +       filter.tracing =3D target_state;
> +
> +       ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, 0);
> +       if (ioctl_status !=3D IOCTL_SUCCESS) {
> +               ksft_print_msg("Error retrieving IOCTL entries with trace=
 filter.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit_revert;
> +       }
> +
> +       if (tags->count !=3D 1) {
> +               ksft_print_msg("Expected exactly 1 entry, but got %llu\n"=
, tags->count);
> +               ret =3D KSFT_FAIL;
> +               goto exit_revert;
> +       }
> +
> +       if (tags->tag[0].counter.trace_on !=3D target_state) {
> +               ksft_print_msg("Entry returned by trace filter does not m=
atch target state\n");
> +               ret =3D KSFT_FAIL;
> +       }
> +
> +exit_revert:
> +       ioctl_status =3D toggle_trace(&target_tag, initial_state);
> +       if (ioctl_status !=3D IOCTL_SUCCESS) {
> +               ksft_print_msg("Failed to revert tracing to initial state=
\n");
> +               ret =3D KSFT_FAIL;
> +       }
> +
> +exit:
> +       free(tags);
> +       return ret;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         int ret;
>
> -       ksft_set_plan(4);
> +       ksft_set_plan(5);
>
>         ret =3D test_filename_filter();
>         if (ret =3D=3D KSFT_SKIP)
> @@ -526,6 +627,12 @@ int main(int argc, char *argv[])
>         else
>                 ksft_test_result(ret =3D=3D KSFT_PASS, "test_filename_fil=
ter\n");
>
> +       ret =3D test_tracing_toggle_and_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_tracing_toggle_and_f=
ilter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_tracing_togg=
le_and_filter\n");
> +
>         ret =3D test_function_filter();
>         if (ret =3D=3D KSFT_SKIP)
>                 ksft_test_result_skip("Skipping test_function_filter\n");
> --
> 2.56.0.385.gd3acb90ef8-goog
>

