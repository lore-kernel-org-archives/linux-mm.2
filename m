Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7FA9D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027656B00AD; Tue, 25 Nov 2025 13:43:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41846B00AE; Tue, 25 Nov 2025 13:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E573C6B00B0; Tue, 25 Nov 2025 13:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41DD6B00AD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:43:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0C30C03B5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:43:05 +0000 (UTC)
X-FDA: 84150001530.30.7731A7A
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id AEB3C100002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:43:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WMffHs1P;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096183; a=rsa-sha256;
	cv=none;
	b=ENOwBhMJ7EmIy3j0ReH5wuyJ+CwYvdJOcOozre4bAZU1V37UnlkIR0sT7yYwhl3m3Nf8Eq
	Y2aWWsaGBb54aWvG7HY6WMaHGdq7KI+lHt27j+A78fvNDgA5vfgPtLJUEYV8qefTcuXdRJ
	5WKox2ErDwDp9aPbyUW02ff2YFWNcKk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WMffHs1P;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sl7d4yuCxVIIt38N0Zrxf3gnAJfLpB9v0r3s+kB8/4=;
	b=rFg86K8dN93v+WrxPKoRhdrhzrsCyLD8uAS9CRDCK8Q1P7XfMqS5SNFoknp6522rEjlcQZ
	zn5EuJNtpLFK99g/bluDB8I7CIGEXrGXhBC+m/iukS9vCgGssxhIQk2m9N8F3U2l1lLrDV
	6VBpvuTDwmiz29IP7a0eaxHum4q/8w0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b735e278fa1so575195866b.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764096182; x=1764700982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sl7d4yuCxVIIt38N0Zrxf3gnAJfLpB9v0r3s+kB8/4=;
        b=WMffHs1PtbcRnIgotxRUYwqZje/iXMzds/lWDrJevjQwDMEYBHYZzy1ofym65/AKQD
         uIfVDAcxmS7g3aO0b9XTXs4oFdkVxqVvslccraMNv2XQrp7TCiBCHjZsSsWgmrSvm5/z
         cBpXbhDXMgR4WYpv4+ZNd2V3s+Jj22TnEXMgZHl/YknVh77cyUpoHNque84R1V5J6lAh
         abNQqAl5uTEf53cF1MDlYD7gDZyf77d9sbOudI9I49QUD/JAmIwkTsDzvNg5gkRFE+Ec
         TTxLAPPJS/2lCyGBTfhr/5XWkKATa8KsYuVySBgQVTxt4V5EsoXEbZUgPXuysGxmuVs8
         d0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764096182; x=1764700982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8sl7d4yuCxVIIt38N0Zrxf3gnAJfLpB9v0r3s+kB8/4=;
        b=KcuId0j5XHRA6KQfKzIy37weY2Dshz9gqE25OTNLCoWY5zVd3vrxNyfbYnS6YbiV8K
         +6VXRaB23rtJJ8VQ72z9gDguDrXnU2qkEX22uUiEYUlCaloLsfG4uH4wJ8AAmACeJH33
         ZhATvaLpfME+gInR79W/P8pl6J27pVF5F1MpbC26waq7C/k4hNSui+Ikn+XJUQXE/yfb
         NTvilXVRHJg75z+WTw5taVOMhbUPnN8NsbFEYeI74dhJwAbB+iSJ70HuuMkjUfUL46Wg
         3t8o25ggTQBW9kLfexLqSe27FZV829u6suDKb8HMf00zO8ZXIxXGDqOIQMKQTZHiAALc
         bk4w==
X-Forwarded-Encrypted: i=1; AJvYcCVzF/XmmPy6koM4aZoW7Sdp7p0tMhQGNRXPc7mgtMmsMmCE+PtFJSUSNuZgFEjwqQDgNrvEJPBSMg==@kvack.org
X-Gm-Message-State: AOJu0Yy0oTdUP6tREyfPA6/GgKspzeX177Gy8ww4ytybyQjdd3CgIznz
	73hm9PMFThDvEmt1n4AohduuOkBN6Ys9+1tFtNyO8YGmlol6VzxwFZbmx1sn+rcLt0pXexCwr/i
	/nf3E9Fcvb/itZmQTnXY/nXJ/VJoTcDw7Ag3QnptAww==
X-Gm-Gg: ASbGncvVlnawmuZ09YB2FDqe+dMU+wOlA6vEPPsJm1xNfwvx4GtRnkM9UbLlSmMuMNi
	NPfvhyS9oXpxbFJgG3lFtVAejHwIk1OJYfKAW24IqR5/pCg2q05BA1B57Q2b3LkvU3sTvcHIDkP
	kcWCAdt6ATfHghUkrYs7wv7I27OWCnd9jWKL+OwpdoYGiC/+efbP2xiyXpX+4cNspw23+35zWjc
	zmah/rt2aS/pLnzPh/7AktxTjhTsSBnj3Z4Qgja9dqvqJUyQPGFhoU6ZElaFvjmGKlb
X-Google-Smtp-Source: AGHT+IGSMJtx2bO2sylBPLFg9TBSoq5VimU44LG0EK6+xX3ux9ORu14DJvucOQEenuC++UueKyTADqq7bGyGwdliFos=
X-Received: by 2002:a17:906:240e:b0:b76:d825:caca with SMTP id
 a640c23a62f3a-b76d825cd38mr74808366b.38.1764096181962; Tue, 25 Nov 2025
 10:43:01 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-20-pasha.tatashin@soleen.com> <aSQPNuFIv0rRr2tp@kernel.org>
In-Reply-To: <aSQPNuFIv0rRr2tp@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 25 Nov 2025 13:42:25 -0500
X-Gm-Features: AWmQ_bnIS98IIm55LCZoBkdO3g3lJwbqWrOuaBnNVwpmXpd9QYlsv3e6UPqSTqM
Message-ID: <CA+CK2bAWe15SkcvWx_hRHvT-RAcudKQ1hRV1htuWanh9Mbh_YA@mail.gmail.com>
Subject: Re: [PATCH v7 19/22] selftests/liveupdate: add test infrastructure
 and scripts
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEB3C100002
X-Stat-Signature: zks3fedx9m56pnwxqjdt9hfcybfq8hhu
X-Rspam-User: 
X-HE-Tag: 1764096183-793153
X-HE-Meta: U2FsdGVkX191thG7HWVXqODk1/6uiUCGM/VhpMdcGZrvscCz7b6qRF5hC7pHoldS8cu640W/aAFemuhMPjYlFRRlWd87A7ryO6Y7ZSPSHju+P0Lnz2MHvm8ZA9aoTLRdWGMaBYn+8EQc2ER2XMROyEouu7TGZGJ3D0QRJgO0CaDghtDiI6SpwoXsWkBUdKOdPLE7h/vjnCI8Ea8hv3CZ9//yWoFEQGZCqD5uxAi4Woi5p5tMvwXX1NBZY3iy8Xycji61fYJfXc1oJ5UINmI6vtv0wxqjU7DbxQyfb5SEKVVImicfQmq5Ln4SMNDYrdHVyP7b46GoGqWp9l9blds4EVoDEmQqdT5HlY2BYyIVkCuGVJUuT9eSdrPpMRZq7WaYgHAg0Z864NhdwXvpUk9u62H6HcABNTQ/hzkD0awG5KLg4KHF+7MT6JKkudUd1F6Q/XzhWUnqEBlggFkwmFqfsiflwwqoEN5IVlleySQZhiw5655sb0rU664dc9a3Mx0XaFnJazMW70B5vbrmA6VhNDMgoQIQQ7jMCpcdu7KkOd8DwsPLWmhf9UOPqN2z8mCohdSYtQEEdB/GDS9KCXPFuPHYMXWUlwk5MysmehGReBR0Wt6LWn51NS4jgm2s///8pDEsXEZ1+OLz//1DapYQs/VBzbgtee/hOt9VFBbI7jVjxrvPfYIbpN0LUisfX7ntHIMyx/72jee+l9RZCFrAdMvP0W21xaXXprVAoa3N1g8lfM1Rl+nWnBRIPZFtF28gSUCI8lyGd45uvkZqseO6V9k0mP0qAhS8DbUFSRvlYVuXT13hWzY5afD0B7gsLXg01X7aikCEHbMh5HcrbP46enlMbWKFSW73O6jro4SLyU60jRY4HC3PgBK0nlFyUm8qy5atyuxLcCOnGcbx2TWQos1shRzUtCfh9y3zISzi5biFkccAgtQLWDCkDCDFFKw22i1wtGwWK0Y/GqWiZ5b
 UTg3oLEf
 ii1GPtRjzjHTuOqFcdmkshqlNqTw2OYtJdJvHiIasLqFZqbnKcVvYugViKn7QGeAHMygSpmoo7SKknSWN8/ZVJ9O44nBsPqdTLnZZ/Q/fh5APZGbwRuINmZrKkxg/gH5FhfkGZj5DfQku2bjgUEvRytZwRko3CfEx3+Rz2GmiENwQBBT7amc8xK+Akir3Cdhp1691mBx+7yhu7HVQDTS+GpIG2fyrbIgxwGgwxPqzQJM7kODKYRE2yeqNXyszYvQJgX0B/vZ6h19Ke3c3U4zTr5aoyMAQdi25oicX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 2:54=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 22, 2025 at 05:23:46PM -0500, Pasha Tatashin wrote:
> > Subject: [PATCH v7 19/22] selftests/liveupdate: add test infrastructure=
 and scripts
>
> Maybe                                                ^ end to end

Done.

>
> > Add the testing infrastructure required to verify the liveupdate
> > feature. This includes a custom init process, a test orchestration
> > script, and a batch runner.
>
> And say here that it's end to end test.

Done

> > +static int is_stage_2(void)
> > +{
> > +     char cmdline[COMMAND_LINE_SIZE];
> > +     ssize_t len;
> > +     int fd;
> > +
> > +     fd =3D open("/proc/cmdline", O_RDONLY);
> > +     if (fd < 0)
> > +             return 0;
> > +
> > +     len =3D read(fd, cmdline, sizeof(cmdline) - 1);
> > +     close(fd);
> > +
> > +     if (len < 0)
> > +             return 0;
>
> Shouldn't we bail out of the test if read of command line failed?

Sure, done.

> > +function cleanup() {
> > +     local exit_code=3D$?
> > +
> > +     if [ -z "$workspace_dir" ]; then
> > +             ktap_finished
> > +             return
> > +     fi
> > +
> > +     if [ $exit_code -ne 0 ]; then
> > +             echo "# Test failed (exit code $exit_code)."
> > +             echo "# Workspace preserved at: $workspace_dir"
> > +     elif [ "$KEEP_WORKSPACE" -eq 1 ]; then
> > +             echo "# Workspace preserved (user request) at: $workspace=
_dir"
> > +     else
> > +             rm -fr "$workspace_dir"
> > +     fi
> > +     ktap_finished
>
>         exit $exit_code

Done

> > +function build_kernel() {
> > +     local build_dir=3D$1
> > +     local make_cmd=3D$2
> > +     local kimage=3D$3
> > +     local target_arch=3D$4
> > +
> > +     local kconfig=3D"$build_dir/.config"
> > +     local common_conf=3D"$test_dir/config"
> > +     local arch_conf=3D"$test_dir/config.$target_arch"
> > +
> > +     echo "# Building kernel in: $build_dir"
> > +     $make_cmd defconfig
> > +
> > +     local fragments=3D""
> > +     if [[ -f "$common_conf" ]]; then
> > +             fragments=3D"$fragments $common_conf"
> > +     fi
>
> Without this CONFIG_LIVEUPDATE won't be set
> > +
> > +     if [[ -f "$arch_conf" ]]; then
> > +             fragments=3D"$fragments $arch_conf"
> > +     fi
> > +
> > +     if [[ -n "$fragments" ]]; then
> > +             "$kernel_dir/scripts/kconfig/merge_config.sh" \
> > +                     -Q -m -O "$build_dir" "$kconfig" $fragments >> /d=
ev/null
> > +     fi
>
> I believe you can just
>
>         cat $common_conf $fragments >  $build_dir/.config
>         make olddefconfig
>
> without running defconfig at the beginning
> It will build faster, just make sure to add CONFIG_SERIAL_ to $arch_conf

I will look into that, so how performance really changes,  I liked
using merge_config.sh as it does not print warnings.

>
> > +     $make_cmd olddefconfig
> > +     $make_cmd "$kimage"
> > +     $make_cmd headers_install INSTALL_HDR_PATH=3D"$headers_dir"
> > +}
> > +
> > +function mkinitrd() {
> > +     local build_dir=3D$1
> > +     local kernel_path=3D$2
> > +     local test_name=3D$3
> > +
> > +     # 1. Compile the test binary and the init process
>
> Didn't find 2. ;-)
> Don't think we want the numbering here, plain comments are fine

Updated comment.


>
> > +     "$CROSS_COMPILE"gcc -static -O2 \
> > +             -I "$headers_dir/include" \
> > +             -I "$test_dir" \
> > +             -o "$workspace_dir/test_binary" \
> > +             "$test_dir/$test_name.c" "$test_dir/luo_test_utils.c"
>
> This will have hard time cross-compiling with -nolibc toolchains

Hm, it works for me, I am not sure with nolibc cross compiler, am I
missing something?

>
> > +
> > +     "$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib          \
> > +                     -fno-asynchronous-unwind-tables -fno-ident      \
> > +                     -fno-stack-protector                            \
> > +                     -I "$headers_dir/include"                       \
> > +                     -I "$kernel_dir/tools/include/nolibc"           \
> > +                     -o "$workspace_dir/init" "$test_dir/init.c"
>
> This failed for me with gcc 14.2.0 (Debian 14.2.0-19):


Updated, removed the extra const, and static.

>
> /home/mike/git/linux/tools/testing/selftests/liveupdate/init.c: In functi=
on =E2=80=98run_test=E2=80=99:
> /home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:111:65: er=
ror: initializer element is not constant
>   111 |             static const char *const argv[] =3D {TEST_BINARY, sta=
ge_arg, NULL};
>       |                                                             ^~~~~=
~~~~
>
> /home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:111:65: no=
te: (near initialization for =E2=80=98argv[1]=E2=80=99)
> /home/mike/git/linux/tools/testing/selftests/liveupdate/init.c:113:37: er=
ror: passing argument 2 of =E2=80=98execve=E2=80=99 from incompatible point=
er type [-Wincompatible-pointer-types]
>   113 |                 execve(TEST_BINARY, argv, NULL);
>       |                                     ^~~~
>       |                                     |
>       |                                     const char * const*
> In file included from /home/mike/git/linux/tools/testing/selftests/liveup=
date/init.c:16:
> /usr/include/unistd.h:572:52: note: expected =E2=80=98char * const*=E2=80=
=99 but argument is of type =E2=80=98const char * const*=E2=80=99
>   572 | extern int execve (const char *__path, char *const __argv[],
>       |                                        ~~~~~~~~~~~~^~~~~~~~
>
> > +
> > +     cat > "$workspace_dir/cpio_list_inner" <<EOF
> > +dir /dev 0755 0 0
> > +dir /proc 0755 0 0
> > +dir /debugfs 0755 0 0
> > +nod /dev/console 0600 0 0 c 5 1
>
> Don't you need /dev/liveupdate node?

That should be created by the kernel itself.

>
> > +file /init $workspace_dir/init 0755 0 0
> > +file /test_binary $workspace_dir/test_binary 0755 0 0
> > +EOF
> > +
> > +     # Generate inner_initrd.cpio
> > +     "$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list_inner" >=
 "$workspace_dir/inner_initrd.cpio"
> > +
> > +     cat > "$workspace_dir/cpio_list" <<EOF
> > +dir /dev 0755 0 0
> > +dir /proc 0755 0 0
> > +dir /debugfs 0755 0 0
> > +nod /dev/console 0600 0 0 c 5 1
>
> And here as well.

Not needed.

>
> > +file /init $workspace_dir/init 0755 0 0
> > +file /kernel $kernel_path 0644 0 0
> > +file /test_binary $workspace_dir/test_binary 0755 0 0
> > +file /initrd.img $workspace_dir/inner_initrd.cpio 0644 0 0
> > +EOF
> > +
> > +     # Generate the final initrd
> > +     "$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list" > "$ini=
trd"
> > +     local size=3D$(du -h "$initrd" | cut -f1)
> > +}
> > +
> > +function run_qemu() {
> > +     local qemu_cmd=3D$1
> > +     local cmdline=3D$2
> > +     local kernel_path=3D$3
> > +     local serial=3D"$workspace_dir/qemu.serial"
> > +
> > +     local accel=3D"-accel tcg"
> > +     local host_machine=3D$(uname -m)
> > +
> > +     [[ "$host_machine" =3D=3D "arm64" ]] && host_machine=3D"aarch64"
> > +     [[ "$host_machine" =3D=3D "x86_64" ]] && host_machine=3D"x86_64"
> > +
> > +     if [[ "$qemu_cmd" =3D=3D *"$host_machine"* ]]; then
> > +             if [ -w /dev/kvm ]; then
> > +                     accel=3D"-accel kvm"
>
> Just pass both kvm and tcg and let qemu complain.

I hated those warnings, this is why I added this "if" in the first place :-=
)

Thank you for your reviews, I am going to send this patch separately
from this series, so let's continue the discussion there.

Pasha

