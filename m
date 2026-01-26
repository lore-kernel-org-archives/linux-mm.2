Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B6AD778BE
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 01:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C476B0005; Sun, 25 Jan 2026 20:40:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A106B0088; Sun, 25 Jan 2026 20:40:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BB26B0089; Sun, 25 Jan 2026 20:40:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCCF46B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 20:40:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D02BD2D1A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:40:22 +0000 (UTC)
X-FDA: 84372409884.16.0F86F59
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F0E4A0003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:40:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtIvEjky;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769391620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOS/I3qY1vByTUV0rzQTBMazz/yNAmJFWVeZH3R10+Y=;
	b=BXNREKK6HDucKQUEi6FIhHgjywuWtw/WkWfemYEAN1Ye8QQ5KZlWwM15SrngZe3GyJCK3l
	AQ7gs2Z45HsZPhakvy2DLJMB1F0o+X9iJ/mcJ5KF+6Fb4KUZL6JWMIBti/tO2ePkzl/amx
	Yj7dTgB/5y0MDWP4b0RagUYMA1ulfPY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769391620; a=rsa-sha256;
	cv=none;
	b=nOhn5ka1nFcskLvZxttVThoO3NAZmkJoK15zrTLnsggc43ksBUIj0CL1rrUsKGmOvWhxV4
	2f7q3ECH27MTtt1Nh0L9fz1qBLIyIG9whg0CKW3if15tC8pM/Y0GgVJBBhwAtrRkeagu7Y
	5B4eDtrsBqkyslUSLREIzxRrlAFebkU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtIvEjky;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769391617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOS/I3qY1vByTUV0rzQTBMazz/yNAmJFWVeZH3R10+Y=;
	b=JtIvEjkyz6fJcB1qcAm9UeGr45TrQiuC4U97SwoSQWERAEd26ARBHVe7+Pw+4xl7KifCNB
	9NYXe7CylOwE4gcUYajwfyysJZAzkYijiu3765UOhj/R84ibbkDA0AHNiazLN02H6fY7JY
	Q2NWiGJKpBl1suunAWTwKhLgjyy1ZxU=
Date: Mon, 26 Jan 2026 01:40:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <8ee851c5676facd43c45cdd5d434d92d85628e43@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH bpf-next v3 09/12] selftests/bpf: Add tests for
 memcg_bpf_ops
To: "JP Kobryn" <inwardvessel@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii
 Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "John Fastabend"
 <john.fastabend@gmail.com>, "KP Singh" <kpsingh@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "Hao Luo" <haoluo@google.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "Peter Zijlstra"
 <peterz@infradead.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Nathan
 Chancellor" <nathan@kernel.org>, "Kees Cook" <kees@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>, mkoutny@suse.com,
 "Jan Hendrik Farr" <kernel@jfarr.cc>, "Christian Brauner"
 <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Brian
 Gerst" <brgerst@gmail.com>, "Masahiro Yamada" <masahiroy@kernel.org>,
 davem@davemloft.net, "Jakub Kicinski" <kuba@kernel.org>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, "Willem de Bruijn" <willemb@google.com>,
 "Jason Xing" <kerneljasonxing@gmail.com>, "Paul Chaignon"
 <paul.chaignon@gmail.com>, "Anton Protopopov" <a.s.protopopov@gmail.com>,
 "Amery Hung" <ameryhung@gmail.com>, "Chen Ridong"
 <chenridong@huaweicloud.com>, "Lance Yang" <lance.yang@linux.dev>,
 "Jiayuan Chen" <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: "Hui Zhu" <zhuhui@kylinos.cn>, "Geliang Tang" <geliang@kernel.org>
In-Reply-To: <b90069a3-86b4-4fba-9ff3-fe5f6c4e425d@gmail.com>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
 <c44accaaaebfc32be13234f82b501a3852ba3f0f.1769157382.git.zhuhui@kylinos.cn>
 <b90069a3-86b4-4fba-9ff3-fe5f6c4e425d@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6F0E4A0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: g6up8gjsdgss5dzxpkrzii39nfx9wrk7
X-HE-Tag: 1769391620-455695
X-HE-Meta: U2FsdGVkX1+vWF6bGiy0Y8yEn0+dpqq0n+vazjQeAmbI0dFhK2QAOsGkOUR6q84JT78fL2VnjgU4Z73PXbfn9KVDZ8CJO3904kAML/l9UB9fe1PSUAPtX9QBy+HYfduY2UsCEMl/HoUXWe/tDHKPvNspW/qZSNqPoGEPXpPpsIZmWWhCL2V7HtDxiFSs6qB+4XeHb5aTROGMHPZs89HdjaK6BDvlo4yaKPAVpPyJE+8GMji3ZW/tAXvMifjz52plWTtaPiFXIPGdAAzzZwifYlvlW5pSipF3iq14gB66/zfLnhB5xqDF+C4nveZfAfjJFHjgdV35r804toMwSZ+2kOmXVQSmY68e7vJyGCIXK/MPQ/tUsgThmvMye+V/p7xdLeMibdXAM65W8ZJFi/U+B0Yk01X89519QHRi8tUzeHnBZWcCDnhvQMXQerG140cRAaRr9HZfUEKRcq49iSlcP+tWsnCT7GhclJj1bkp4A9Z20dwytRT45YYgRDFo6F3qd5tVOAphIcPWuN65vjooUo6geSXt6pM0oLaHxpwYXZ90B0ksVgBSqIBFLcTY7c0vHtDlcZTYSFL1T7/F/EJp/N8hSfxjoje5RHC+tRr8JPx4CoB2ZZRiTdAaDyOUCH5/1GOqR/TFNw55EI8evbjp7yfOXwIuho5lSyHg/OlyeMdgfbeCsgI7YjQzHu/Z+BUGJj8+NAP8LFUnspCRdNumPbpZFENQUyFX7iG9P/35nOIE5Nk+u+9NyWEKtWKlSDDqD31k3UrHY9L0CCO3gFLv14WckqArbgRCcvORgtcYuFOXpcJAQ/ISH7pNzg3VP6oi68Beoz0df10MPZ/TGcXHyNhX0JDqWRkUuARbdGv1B8CBr+4EvRg5+FcZ96On3zWYu540jIAa8g8mTswBDfvmyD6o0cVHjwQ1ade4sGgnkIz0L4GeVNV2AaqUD/Jpi2bWIMKH30Tju6gtjVYJgUH
 J3c3bnFd
 HOoCSiX/zIWRyM3IvtG02Nuwmn3B/7AyJDNfNtW0N9M6oMHEZKoAwsaNpPyAbQbdhWnhH8TMz2Af0hjZF37NV7VTpsZEHvQpuYMBNMeVoDg4i4x2/eEKm/SephHMnCo3M2Vg3GhB1pIqadWxSpGJ2MH+F+MnpcNHWM1/k84g6EAnb7xr3HElBOVYLiudYImyGOFFHkOOuWgGv1igaXv004KRF/cJJG0D10GqXQrGywgTbADapVxrVq9ZMEOjGxi5+A65l7l+4E7nwaUnK4VX2vqjJ859PbJY3ghdWFu6PH22VzGwLnTqI6ymWHFm6NuURK3IPj3bwOvK3eCGFDUx226wpXEjrme6u+2crVo2yYHk8uARITgP7HWQ4lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8824=E6=97=A5 04:47, "JP Kobryn" <inwardvessel@gmail=
.com mailto:inwardvessel@gmail.com?to=3D%22JP%20Kobryn%22%20%3Cinwardvess=
el%40gmail.com%3E > =E5=86=99=E5=88=B0:


>=20
>=20Hi Hui,
>=20
>=20On 1/23/26 1:00 AM, Hui Zhu wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >  Add a comprehensive selftest suite for the `memcg_bpf_ops`
> >  functionality. These tests validate that BPF programs can correctly
> >  influence memory cgroup throttling behavior by implementing the new
> >  hooks.
> >  The test suite is added in `prog_tests/memcg_ops.c` and covers
> >  several key scenarios:
> >  1. `test_memcg_ops_over_high`:
> >  Verifies that a BPF program can trigger throttling on a low-priority
> >  cgroup by returning a delay from the `get_high_delay_ms` hook when a
> >  high-priority cgroup is under pressure.
> >  2. `test_memcg_ops_below_low_over_high`:
> >  Tests the combination of the `below_low` and `get_high_delay_ms`
> >  hooks, ensuring they work together as expected.
> >  3. `test_memcg_ops_below_min_over_high`:
> >  Validates the interaction between the `below_min` and
> >  `get_high_delay_ms` hooks.
> >  The test framework sets up a cgroup hierarchy with high and low
> >  priority groups, attaches BPF programs, runs memory-intensive
> >  workloads, and asserts that the observed throttling (measured by
> >  workload execution time) matches expectations.
> >  The BPF program (`progs/memcg_ops.c`) uses a tracepoint on
> >  `memcg:count_memcg_events` (specifically PGFAULT) to detect memory
> >  pressure and trigger the appropriate hooks in response. This test
> >  suite provides essential validation for the new memory control
> >  mechanisms.
> >  Signed-off-by: Geliang Tang <geliang@kernel.org>
> >  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >  ---
> >=20
>=20[..]
>=20
>=20>=20
>=20> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/t=
ools/testing/selftests/bpf/prog_tests/memcg_ops.c
> >  new file mode 100644
> >  index 000000000000..9a8d16296f2d
> >  --- /dev/null
> >  +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> >  @@ -0,0 +1,537 @@
> >=20
>=20[..]
>=20
>=20>=20
>=20> +
> >  +static void
> >  +real_test_memcg_ops_child_work(const char *cgroup_path,
> >  + char *data_filename,
> >  + char *time_filename,
> >  + int read_times)
> >  +{
> >  + struct timeval start, end;
> >  + double elapsed;
> >  + FILE *fp;
> >  +
> >  + if (!ASSERT_OK(join_parent_cgroup(cgroup_path), "join_parent_cgrou=
p"))
> >  + goto out;
> >  +
> >  + if (env.verbosity >=3D VERBOSE_NORMAL)
> >  + printf("%s %d begin\n", __func__, getpid());
> >  +
> >  + gettimeofday(&start, NULL);
> >  +
> >  + if (!ASSERT_OK(write_file(data_filename), "write_file"))
> >  + goto out;
> >  +
> >  + if (env.verbosity >=3D VERBOSE_NORMAL)
> >  + printf("%s %d write_file done\n", __func__, getpid());
> >  +
> >  + if (!ASSERT_OK(read_file(data_filename, read_times), "read_file"))
> >  + goto out;
> >  +
> >  + gettimeofday(&end, NULL);
> >  +
> >  + elapsed =3D (end.tv_sec - start.tv_sec) +
> >  + (end.tv_usec - start.tv_usec) / 1000000.0;
> >  +
> >  + if (env.verbosity >=3D VERBOSE_NORMAL)
> >  + printf("%s %d end %.6f\n", __func__, getpid(), elapsed);
> >  +
> >  + fp =3D fopen(time_filename, "w");
> >  + if (!ASSERT_OK_PTR(fp, "fopen"))
> >  + goto out;
> >  + fprintf(fp, "%.6f", elapsed);
> >  + fclose(fp);
> >  +
> >  +out:
> >  + exit(0);
> >  +}
> >  +
> >=20
>=20[..]
>=20
>=20>=20
>=20> +static void real_test_memcg_ops(int read_times)
> >  +{
> >  + int ret;
> >  + char data_file1[] =3D "/tmp/test_data_XXXXXX";
> >  + char data_file2[] =3D "/tmp/test_data_XXXXXX";
> >  + char time_file1[] =3D "/tmp/test_time_XXXXXX";
> >  + char time_file2[] =3D "/tmp/test_time_XXXXXX";
> >  + pid_t pid1, pid2;
> >  + double time1, time2;
> >  +
> >  + ret =3D mkstemp(data_file1);
> >  + if (!ASSERT_GT(ret, 0, "mkstemp"))
> >  + return;
> >  + close(ret);
> >  + ret =3D mkstemp(data_file2);
> >  + if (!ASSERT_GT(ret, 0, "mkstemp"))
> >  + goto cleanup_data_file1;
> >  + close(ret);
> >  + ret =3D mkstemp(time_file1);
> >  + if (!ASSERT_GT(ret, 0, "mkstemp"))
> >  + goto cleanup_data_file2;
> >  + close(ret);
> >  + ret =3D mkstemp(time_file2);
> >  + if (!ASSERT_GT(ret, 0, "mkstemp"))
> >  + goto cleanup_time_file1;
> >  + close(ret);
> >  +
> >  + pid1 =3D fork();
> >  + if (!ASSERT_GE(pid1, 0, "fork"))
> >  + goto cleanup;
> >  + if (pid1 =3D=3D 0)
> >  + real_test_memcg_ops_child_work(CG_LOW_DIR,
> >  + data_file1,
> >  + time_file1,
> >  + read_times);
> >=20
>=20Would it be better to call exit() after real_test_memcg_ops_child_wor=
k()
> instead of within it? This way the fork/exit/wait logic is contained in
> the same scope making the lifetimes easier to track. I had to go back
> and search for the call to exit() since at a glance this function
> appears to proceed to call fork() and waitpid() from within both parent
> and child procs (though it really does not).
>

I will fix it.

Best,
Hui

