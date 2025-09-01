Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AB1CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9428B8E001F; Mon,  1 Sep 2025 08:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919678E000F; Mon,  1 Sep 2025 08:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F2D8E001F; Mon,  1 Sep 2025 08:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB698E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:51:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D5C8160838
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:51:02 +0000 (UTC)
X-FDA: 83840666364.23.79D839E
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF70040009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:50:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NKJsnEKJ;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756731060; a=rsa-sha256;
	cv=none;
	b=O4/FIPQok8Onglma0aGd/ONlvkjuX+hpEfPgLuKJ1nUsT80pWNaSsXycCHR0+s4+PIojYH
	9OctzdiuNQiC9mhZWiNltofJHAyX/5VJa8dQSLXaqjoynssPEB7+wuA5w2MLQ0YvirDJli
	Y7UnIUovc5+deciwd6E5ThaUt63TxC4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NKJsnEKJ;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RojBF6ZwlxZFZwX/0b1dSoMQba7iu3ojoy33z4p+HaQ=;
	b=zVReC8MLm/GXIJiW8Y/Ob9KHKwQmz/Hg3bykWj5Q01E5CA41SykUg27msoeEbcXa++tBfi
	fIzcb54dkpPpYBCp/U6WmxpxQVkk3ZQephiYZbynPrcWFezGGr50Rdj9clhUTxm/Fnde93
	diYMKYtH1PXh5V4G0ku675G9MW/3VlQ=
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-8960a3fb405so1146681241.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756731058; x=1757335858; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RojBF6ZwlxZFZwX/0b1dSoMQba7iu3ojoy33z4p+HaQ=;
        b=NKJsnEKJidOPzYy0hSdEsKuBgcPeBUFjypaAkNHhY8ISwblCQfKQWPozNICcCBQgNu
         pdtE8BhhpRAft36nexO+LdlhohfddVUK9jROmPXx1GOOhLW5XHpSjF9EJmGuR62J51PC
         2NDZ2olbLbyTkTe1+HfX6/MJUha2WndZTfyScGuMeP4wP6oJ5QWzsG9wCrztO8DprSJW
         VgBqouhjprN40tnRoQE+fH3iO3w3gPMA4BWX+l99qtLg4BDjNT6aE2OkZ3P4Sf2VKOE6
         Mu8AoEWLlCF1jJSAhqjONAxCjNopHA8s4IvH4rWkZ2ADK4fQdCgVSNWC6ZzgFNs4BTd5
         1vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731058; x=1757335858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RojBF6ZwlxZFZwX/0b1dSoMQba7iu3ojoy33z4p+HaQ=;
        b=xSIdqZ6p6EQr+nHsqoHLOAJv/eF17R1m/QBXcqf2PItUzVFW0xi07Fa/bO0CY88Nfx
         4D5nz7tKJSRfKSBP38iigciKcTX9uwMZzWh7DrBNzTM0LgCRhHBDwVEVLuLMXrKnJSVI
         pNmImysMRW2jPorvvTroVDE7AM+dHlaat/GugyiTWs1EShrV9eRWNeBAg1D9kemZJMJl
         4vKgkOjFKZsbdeDF3a2TxIPWkbZyrnS+g4UpKZd/+NLauTOlKUqvvMQ+8d5ImIxzLVh5
         eSAKTtUlMagRBoUgHAR0k7BRF449g1lG2mvV8+yjeqHZxiTNJklNDy4IZK8FvC3gRL8B
         Ncdg==
X-Forwarded-Encrypted: i=1; AJvYcCVG6CLKsVsNCg5pxceIiQuLAL7pni9kAhFEZT56At3bE3rlPeiENj5IKTcSASd3Ip6HSAMbweNVKA==@kvack.org
X-Gm-Message-State: AOJu0Ywg2FdGRsZA7VomiV4Vj/yWlLalw7ptmDZt1+Ca4cDMPZWsw8rC
	cQMVwxD6Qw6T8y7hZsEONqBBIMWrSYy8G49QDbR/okgiej8v3JFn1WPhhDdjeWDieUGFD7HvpMU
	8bE7dnVw2pFrk/usxcNs8XGanFmG7BZMfrDKaPJhZKg==
X-Gm-Gg: ASbGncvvICGtussjE0VF3INO1wPm2vp8ksk5KZddQcqo3zRoS4gbrf+LBjELjF+9aEM
	w+mudF3aPqSD/Vwn6ENPlu8Z8bGcJG4TdvfgUc4mQN3abkT0nXH2zR8nUqBRVUpiZcgInZfK3Oc
	mli1zzrzWM31a5TPMdrpa5W8Xe3Nitg6wDBRwVpSPFO/zz9lJbrObhs8Yq9iomjpat8bR8hF7Mf
	G2qAabC3rc7pJmRXZMKv1GRfUTq8QI=
X-Google-Smtp-Source: AGHT+IHr9UCL19brxa2iKAokFlw9VR4MD7FOmMAqfdtgQT+g1vRFoxL2i+IO+GvaPMnobuW4oatWNjOm6C5v2o0ix98=
X-Received: by 2002:a05:6102:6447:b0:523:6f5:5b18 with SMTP id
 ada2fe7eead31-52b1b2eca8fmr2157651137.9.1756731058441; Mon, 01 Sep 2025
 05:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250825145719.29455-1-linyongting@bytedance.com>
 <20250825145719.29455-5-linyongting@bytedance.com> <18530429-cac2-42a4-891e-24033dc54461@oracle.com>
In-Reply-To: <18530429-cac2-42a4-891e-24033dc54461@oracle.com>
From: Yongting Lin <linyongting@bytedance.com>
Date: Mon, 1 Sep 2025 20:50:47 +0800
X-Gm-Features: Ac12FXzEc3BxXpFrvQO5A4KgSDp4VDpvBoAfQRVXMGVwFUBvUT7kQaY8ahX-wSk
Message-ID: <CAFuXZ_UY6RrOVmTayW-DdxQX9TE978LPx7ad=Pzr01j1cZ4o2Q@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 4/8] mshare: selftests: Add test case
 shared memory
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: khalid@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF70040009
X-Stat-Signature: 9frms1bynddhtzzx6ug6nyk3u99c7rr4
X-Rspam-User: 
X-HE-Tag: 1756731059-19426
X-HE-Meta: U2FsdGVkX18jhnycs1aJIkC3GAOEazww5yXK5qRKMeoqNHs57Giwkbt1p521OMJs967TZad/2BnHHTvXOYdjaXX6vSeb3npwHDbelU6/8Oet1HjnqMxhaeHvVhzVEukuR++Z77SKb6zRScr8bnrCoeE5DQvAvw1O1CaMbE7kxcKabsSHHW/yUrwJXYsE1KiKAt18lU1hciMpPulraTOrE3TWNCwqqI+7erJ96YuUVYmAKTsGn+hmfVFNLco1XSZ8OqY8q+SrJHeUo29qO/jcfQ+Hqu3HH/tUAV+/R1CmZguDUJ7peCh2L0hlfes5+5ts+ZTrnB7kPX9yxM2gdtIoJtklAi4KQ7p4u9NwVtXQHnLSOnAG3uhACJujCue8HOz9U7Y7MUYUL/arl6EbgH/+tVDOgprba6B3hSlRDr2/+y5SY/ayoxXeaypj8uf/qVZ0F0N830g7k6H6ppvJNUAb+pWVNWVeh5Vbp0fL00KVvKpwQtgUaDVO1fz6kbiMXMaTBz8UmliQmjwfzgdZ0eQ5DchuUCLneHvA95SNfE94qStrwGdtvlCYKYsa5ntkEFZc5q/8ulKlyOGBDIA1bBc4KTsI15kvjg6o+IHYsctB9xkCTEmjIUIHQEnjbvPrTP4WYhc/UT6YiWIQazH/r/R1ZD/1QrY+qQAagEdIeRsEq8YmzBXYNfOIAnGoDj3c2SJNWBgNaTl7XNrPE3ZMcRrWZuIp1oRVUMg7vFIUPa4aEcOGIRW2BSCuVLwFoL3CcOxcyK63CF+7XvZHEveIFZJpiSyqpJnNE1ByTKIBcUer9u57xa0xqTo/ae28S8o/DAT8Vm4UMEDc2du5mARUwpARP9YRIs08bn/0Zgb77aViFh1j/NY2ELaWPzA6jRiYFtjpiNcjVixfhm2fMbgfmSAHkuCxh8Vp7+xsFgNiuJDfVlIS24s8aPQDNX06dSlBHMaSBvGZWdfP0LLv+zDriwb
 VlvgGK9n
 z7n/DBpYBAgJ7N5xW6VLM9/ASR2LtalTMOZJw3H5HSS/aOlTUrTWce2w/ntFnxlGzv6z658Ry2ZOHbyv8PQTl2MKm9dbcLZYWGf/FwbpQgCuCPZBK3H01poh9zE1Oy6Wdd806PCGE+AnkTTxSTSzOCBGDZjeVrMNXt8NvoNllek/Qnxdk9wgesI5EMIDfRRrorcmGDSgmD50ZEXtCwt7DC1v1vOxlF+sNNg0S97ADovC/tYECChQoqrXICPl3ZRfDDfE/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 9:00=E2=80=AFAM Anthony Yznaga
<anthony.yznaga@oracle.com> wrote:
>
> Hi Yongting,
>
> Thank you for doing this. This is a great start for testing mshare.
> I do have some comments below.
>
> On 8/25/25 7:57 AM, Yongting Lin wrote:
> > This test case aims to verify the basic functionalities of mshare.
> >
> > Create a mshare file and use ioctl to create mapping for host mm
> > with supportive flags, then create two processes to map mshare file
> > to their memory spaces, and eventually verify the correctiness
> > of sharing memory.
> >
> > Signed-off-by: Yongting Lin <linyongting@bytedance.com>
> > ---
> >   tools/testing/selftests/mshare/basic.c | 81 +++++++++++++++++++++++++=
-
> >   1 file changed, 79 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/sel=
ftests/mshare/basic.c
> > index 35739b1133f7..2347d30adfee 100644
> > --- a/tools/testing/selftests/mshare/basic.c
> > +++ b/tools/testing/selftests/mshare/basic.c
> > @@ -3,9 +3,86 @@
> >   #include "../kselftest_harness.h"
> >   #include "util.c"
> >
> > -TEST(basic)
> > +#define STRING "I am Msharefs"
> > +
> > +FIXTURE(basic)
> > +{
> > +     char filename[128];
> > +     size_t align_size;
> > +     size_t allocate_size;
> > +};
> > +
> > +FIXTURE_VARIANT(basic) {
> > +     /* decide the time of real mapping size besed on align_size */
> > +     size_t map_size_time;
> > +     /* flags for ioctl */
> > +     int map_flags;
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(basic, ANON_512G) {
> > +     .map_size_time =3D 1,
> > +     .map_flags =3D MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(basic, HUGETLB_512G) {
> > +     .map_size_time =3D 1,
> > +     .map_flags =3D MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIX=
ED,
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(basic, ANON_1T) {
> > +     .map_size_time =3D 2,
> > +     .map_flags =3D MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(basic, HUGETLB_1T) {
> > +     .map_size_time =3D 2,
> > +     .map_flags =3D MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIX=
ED,
> > +};
> > +
> > +FIXTURE_SETUP(basic)
> >   {
> > -     printf("Hello mshare\n");
> > +     int fd;
> > +
> > +     self->align_size =3D mshare_get_info();
> > +     self->allocate_size =3D self->align_size * variant->map_size_time=
;
> > +
> > +     fd =3D create_mshare_file(self->filename, sizeof(self->filename))=
;
> > +     ftruncate(fd, self->allocate_size);
> > +
> > +     ASSERT_EQ(mshare_ioctl_mapping(fd, self->allocate_size, variant->=
map_flags), 0);
>
> The tests should differentiate between how much VA space is allocated to
> an mshare region (i.e with ftruncate()) and how much memory is allocated
> within an mshare region through the ioctl. While the bounds of an mshare
> region need to be aligned to 512 GB, the memory allocated within it does
> not. Right now the tests will try to map 512 GB or 1 TB of anon or
> hugetlb memory in an mshare region which will fail on smaller systems to
> due to insufficient memory. Better to allocate smaller amounts so the
> tests can run on more systems.
>
> Anthony

I Changed my code to allocate a smaller chunk of memory (i.e.
4K/8K/2M/4M), and these tests are passed.

But I found something different:
step1:  ftruncate a mshare file to 512G
step2:  ioctl map 8K
step3: but after that, I am going to mmap 8K to a process but it
fails, then I have up to mmap 512G memory to process.
step4: Accessing the memory within the 8K boundary is fine but get
segfault after exceling the boundary (as the vma of host mm only holds
a memory region of 8K)

Should the mmap region keep consistent with the ioctl map region in
size? (currently, ioctl map region is 8K, but mmap region is 512G)

Yongting
>
> > +     close(fd);
> > +}
> > +
> > +FIXTURE_TEARDOWN(basic)
> > +{
> > +     ASSERT_EQ(unlink(self->filename), 0);
> > +}
> > +
> > +TEST_F(basic, shared_mem)
> > +{
> > +     int fd;
> > +     void *addr;
> > +     pid_t pid =3D fork();
> > +
> > +     ASSERT_NE(pid, -1);
> > +
> > +     fd =3D open(self->filename, O_RDWR, 0600);
> > +     ASSERT_NE(fd, -1);
> > +
> > +     addr =3D mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
> > +                    MAP_SHARED, fd, 0);
> > +     ASSERT_NE(addr, MAP_FAILED);
> > +
> > +     if (pid =3D=3D 0) {
> > +             /* Child process write date the shared memory */
> > +             memcpy(addr, STRING, sizeof(STRING));
> > +             exit(0);
> > +     }
> > +
> > +     ASSERT_NE(waitpid(pid, NULL, 0), -1);
> > +
> > +     /* Parent process should retrieve the data from the shared memory=
 */
> > +     ASSERT_EQ(memcmp(addr, STRING, sizeof(STRING)), 0);
> >   }
> >
> >   TEST_HARNESS_MAIN
>

