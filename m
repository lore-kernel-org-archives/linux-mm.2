Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD998CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6FAA8E0010; Fri, 10 Oct 2025 04:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47588E0002; Fri, 10 Oct 2025 04:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D718E0010; Fri, 10 Oct 2025 04:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 949408E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:07:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42712B6C44
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:07:16 +0000 (UTC)
X-FDA: 83981474472.12.62284D0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1A5381C000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:07:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j6G2yvWW;
	spf=pass (imf20.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760083633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/qr0Ms7LEN+ZoUHPx1IEnEP/EsOxXGU+zPY1uEN6FU=;
	b=TUGPCJA7Bw437u9QC8Uad/Vqj931gAG5vK+YauTsMa6KOSkDyGgEBaMCH6TLqoztTf0lga
	gXIKPqAWxJ15vteTHWiPh15tIjU3/Ly3Rba4F4j3pmqFmB332RnDKHOBhuEupc+jFgkEzF
	440Ve3W4APphDjsk7fUI2f8LGEu3mZc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j6G2yvWW;
	spf=pass (imf20.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760083633; a=rsa-sha256;
	cv=none;
	b=UqWyM0WxibZtEn87iHucE3vcLgO4ved44BRAZGtNMNxOFITbJyyAzDkMiqDzH46wSQ5JFS
	VtDVXKL/fF1b1zzLt4ocOBFW3FljNWtbK8HOiCyOZjJaRc+UULLLzYPBqoJx1bGQL6DODb
	n4g2x+atPAvF1KShJqhMWmtr6CkoYe8=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599KiJvD031684;
	Fri, 10 Oct 2025 08:07:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1/qr0M
	s7LEN+ZoUHPx1IEnEP/EsOxXGU+zPY1uEN6FU=; b=j6G2yvWWW3jFdWYS/Y4YDL
	7PQLqzT4jngEaR+HIgK2YZK6mE9NqznC3z+LV3XKpMzRmM7wnyTCyol+qXMsuDoL
	fo0HP1VmJUX1OrzHhDyJYqn0EeFCaa8MQU1d0B0nSvLiyu+HFb4sYH2Y/P93m+Dd
	pgWyTE1hkodezgaMc6atE8goVPVp4O3azaM/xvp/Gr5n+EU7mh0YIDfAUeDFQy8S
	demmxJ1CELBljpipQq/JMZHeMQIF0OFmg+MweO9E26OLxMNhuG+aOzY19btYejIU
	CPtL8CvbVusBYB6vuohLGFBAMAcJmEBbij/Ccma26LEtBLg1di2ZIqKEwJmqL/IQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv829j24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:07:09 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59A879qq012514;
	Fri, 10 Oct 2025 08:07:09 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv829j23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:07:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A7uiql020975;
	Fri, 10 Oct 2025 08:07:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv9n0ueb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:07:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A875Lh51446214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:07:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B335320179;
	Fri, 10 Oct 2025 08:07:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36BAD20177;
	Fri, 10 Oct 2025 08:07:05 +0000 (GMT)
Received: from [9.111.16.15] (unknown [9.111.16.15])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Oct 2025 08:07:05 +0000 (GMT)
Message-ID: <335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com>
Date: Fri, 10 Oct 2025 10:07:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots are
 allocated yet
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
 <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
Content-Language: en-US
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
In-Reply-To: <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KrpAGGWN c=1 sm=1 tr=0 ts=68e8bead cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=NEAV23lmAAAA:8 a=VnNF1IyMAAAA:8
 a=088SzXbCcwtnasAlsdMA:9 a=QEXdDO2ut3YA:10 a=HhbK4dLum7pmb74im6QT:22
X-Proofpoint-GUID: 6u5H5Z_Cfr6xiadmAO8XAYgVd0Gd3Ceo
X-Proofpoint-ORIG-GUID: xhPR6IrF8eCnckm759wuwrhZdEVGFJYo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX1aFYWzzRgWq7
 t301c9U/pZtABrD4AzRt83sHUHTFyeko/JV6aut+5gaWPRgA1+jbDTqxKK7hUoD2FrSgQKflQ28
 mq3S2MB1HmowEFge3ZsSSW0yHYLa5niIRRNiwTA9o1UGRp9CSGGseWiPXioSKTSBj5CR9GVIenw
 3Ta1kGTj9mLHdLYtIA6C4RdBCHCwXG71dDHQjS6B4ZQW9w0DEN5NSEligiVDmrMBnZClASNLzID
 LRcrAUSFtzkusK71Z1A1dw/rTop4WlyBjMA9/Wrgstc0h09512LlGGGRp9WxqA3D5a1UDJZGzL6
 NcydzGl4R5Oow6zgiWZBBWv/EsEcfxTWdbnNcTyOPbBhTv064pbXqByjUY9Dg2jWWHiTE60PQE+
 GOPEAwH4cYrbMKeIF3fMMaGVJ15U7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A5381C000A
X-Stat-Signature: 4q8mz3fgerojka8cbrz7km8h3jzzry6f
X-Rspam-User: 
X-HE-Tag: 1760083631-30208
X-HE-Meta: U2FsdGVkX19C3lcu10PLot51WWAn4iUDAe/rfbpvu3nfO6y6jtjygc+i6IpzB45F3JOV2QGvlU6jynOQYj8chjkQbXTHmx2lIGysgfLnHi80tU0fU1Ow/577RiJmZnkgMgKhwIFFaDmBtXE/CFPfdkb6zfapdYqKODIRs6ZXDsqv8tQBIcndzG99kCLtBoj+fxf/PrvIXnatjVsqnLvoZrsQ42CbFYQmTO/t84Fpk7EiDfpPe6B60FKBCYKAT2832QqSpHegFaBuwBUFOiCb9mG4HbafB68XlGyjCqI0FRIVj/emPsaGSjZtm2r5qdrBn/6L5j/aw0wS7QVboIayxg0QtYTiHpaUHPYFYLwEBNq6lE9+L20Y6/v/AgNxAQAfpHl56oTG9jFAJRNmzmXhj+JEq4m90tBZnqAbBvrV29Kw1acqueMBcUf35+1VR+V6w/drymNtC1+zGKda2qCyHmbetL5Rjk1IwcPSROzSkIakbyMvcudWtDqMvj7uv7XKHe0uIdde9MG08mW9+UZ8kQItHvFKvSDeM+6TTal1gehqQl91pHfFk1eylRmCHqFfhu1jO/esaEsGbvTN2SHMe25FewXqET7iYm3mhrqEsnhOgPA8GZ2jMFYwNwTqlYnugtmAmmGpBMVy7ZQYw2YkSf1YYlQfbTJy+n2cWabyOyYdbhZcPcBcZykkFPODCVon0j/+lejh/MWd/VJxtct+l7rKCV5ZeCSaKr5cPwZiwqGsfn3/DMqY4OoRj3f50OUrIr7TY+saqD+WEhSfAmWRrDdx5ZObsCklCN/RCtABTlPTeZ8BmEGzoN5wtMFdlKXh4FnC/u13ALMS2OM0rN7qrv2pK3dsfMbvPLkJG6vinCeFU2i4ZoQBKUEXpL9F3w2mn1/ODSbwhCHfSUfdQOA8zwvJu4S9hKS6m6gF9zeiOR+JNdfe2oPn3BU16CkeXbyP8sz5Ov8CzLzG3TMCyyG
 AXw1HNIL
 pSGq4QaKHg7mYJ7MOaqedYYpo87zlA3gOsUlfKJHT2sQvDwIYjCx6t4fY+59QDEG6bEM7Sw1lc2WXJ2d6LB413c1cqwU+5rb5MnHAz5zHTxuPUH/qTM5AtYxMlo1nV+mS3MrhEGDA7ENw/xLK6O/gD9WJqzK2bl1BsmMoeEj/QYw9cDmGyFBfhBiwQLLcGNbOKIu+x7953qQl5tpyIm+ZRbdhEkINtykzVSic+uAuC6HVMjx5vOOd8vGJWfC5yS3+t6RmomUgLgPbaVdieaKwt4b+YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 05:31, Andrew Morton wrote:
> On Tue, 30 Sep 2025 13:56:01 +0200 Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com> wrote:
> 
>> If no stack depot is allocated yet,
>> due to masking out __GFP_RECLAIM flags
>> kmsan called from kmalloc cannot allocate stack depot.
>> kmsan fails to record origin and report issues.
>>
>> Reusing flags from kmalloc without modifying them should be safe for kmsan.
>> For example, such chain of calls is possible:
>> test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
>> slab_alloc_node -> slab_post_alloc_hook ->
>> kmsan_slab_alloc -> kmsan_internal_poison_memory.
>>
>> Only when it is called in a context without flags present
>> should __GFP_RECLAIM flags be masked.
>>
>> With this change all kmsan tests start working reliably.
> 
> I'm not seeing reports of "hey, kmsan is broken", so I assume this
> failure only occurs under special circumstances?

Hi,

kmsan might report less issues than it detects due to not allocating 
stack depots and not reporting issues without stack depots. Lack of 
reports may go unnoticed, that's why you don't get reports of kmsan 
being broken.

I'm not sure what exactly causes me to hit this issue, but I reproduce 
it pretty reliably on one s390x machine and two x86_64 machines. I 
didn't try more different machines yet.

Here's how I reproduce it on Fedora 42 x86_64 machine using podman.

I've got following files in same directory:

$ ls
busybox.init  busybox.patch  debug.config  kmsan.config 
kmsan.Dockerfile  qemu.sh
$ cat busybox.init
#!/bin/sh

mount -t proc none /proc
mount -t sysfs none /sys

cat <<!


Boot took $(cut -d' ' -f1 /proc/uptime) seconds

         _       _     __ _
   /\/\ (_)_ __ (_)   / /(_)_ __  _   ___  __
  /    \| | '_ \| |  / / | | '_ \| | | \ \/ /
/ /\/\ \ | | | | | / /__| | | | | |_| |>  <
\/    \/_|_| |_|_| \____/_|_| |_|\__,_/_/\_\


Welcome to mini_linux


!
exec /bin/sh
$ cat busybox.patch
diff --git a/libbb/appletlib.c b/libbb/appletlib.c
index d9cc48423..a0c502fde 100644
--- a/libbb/appletlib.c
+++ b/libbb/appletlib.c
@@ -718,8 +718,8 @@ static int find_script_by_name(const char *name)
         return -1;
  }

-int scripted_main(int argc UNUSED_PARAM, char **argv) 
MAIN_EXTERNALLY_VISIBLE;
-int scripted_main(int argc UNUSED_PARAM, char **argv)
+int scripted_main(int argc UNUSED_PARAM, char **argv) 
MAIN_EXTERNALLY_VISIBLE //;
+//int scripted_main(int argc UNUSED_PARAM, char **argv)
  {
         int script = find_script_by_name(applet_name);
         if (script >= 0)
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh 
b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 5075ebf2d..c644d1d48 100755
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -45,9 +45,9 @@ trap "rm -f $tmp" 0 1 2 3 15

  # Check if we can link to ncurses
  check() {
-        $cc -x c - -o $tmp 2>/dev/null <<'EOF'
+        $cc -x c - -o $tmp <<'EOF'
  #include CURSES_LOC
-main() {}
+int main() { return 0; }
  EOF
         if [ $? != 0 ]; then
             echo " *** Unable to find the ncurses libraries or the" 
   1>&2
$ cat debug.config
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_KERNEL=y
CONFIG_GDB_SCRIPTS=y
$ cat kmsan.config
CONFIG_KUNIT=y
CONFIG_KMSAN=y
CONFIG_KMSAN_CHECK_PARAM_RETVAL=y
CONFIG_KMSAN_KUNIT_TEST=y
CONFIG_FRAME_WARN=4096
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_TRACE_PREEMPT_TOGGLE is not set
# CONFIG_DEBUG_VIRTUAL is not set
$ cat kmsan.Dockerfile
FROM fedora:42

RUN dnf update -y ; dnf install -y git bash-completion util-linux nano 
patch \
         qemu qemu-kvm openssl openssl-devel ncurses-devel gcc gcc-c++ 
clang clang++ \
         flex bison bc awk cpio gzip sudo elfutils-libelf-devel pod2html 
glibc-static

RUN useradd -m user ; echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

RUN mkdir src ; cd src ; git clone --depth=1 --branch v6.17 
https://github.com/torvalds/linux ; \
         git clone --depth=1 https://github.com/mirror/busybox

COPY --chown=user:user busybox.patch /home/user/busybox.patch
COPY --chown=user:user qemu.sh /home/user/qemu.sh
COPY --chown=user:user kmsan.config /home/user/kmsan.config
COPY --chown=user:user debug.config /home/user/debug.config
COPY --chown=user:user busybox.init /home/user/busybox.init

RUN chmod +x qemu.sh ; cd src/linux ; make CC=clang defconfig ; \
         cat ~/kmsan.config >> .config ; cat ~/debug.config >> .config ; \
         make CC=clang -j8

RUN cd src/busybox ; patch -p1 < ~/busybox.patch ; make defconfig ; \
         sed -i -e 's:CONFIG_TC=y:# CONFIG_TC is not set:' -e 
's:CONFIG_FEATURE_TC_INGRESS=y:# CONFIG_FEATURE_TC_INGRESS is not set:' 
.config ; \
         sed -i -e 's:# CONFIG_STATIC is not set:CONFIG_STATIC=y:' 
.config ; \
         make -j8 ; make install

RUN mkdir src/initramfs ; cd src/initramfs ; mkdir -p bin sbin etc proc 
sys usr/bin usr/sbin ; \
         cp -a ~/src/busybox/_install/* . ; cp ~/busybox.init ./init ; 
chmod +x init ; \
         find . -print0 | cpio --null -ov --format=newc | gzip -9 > 
../initramfs.cpio.gz
$ cat qemu.sh
#!/bin/bash
exec qemu-system-x86_64 -m 2G -smp 4 -kernel 
~/src/linux/arch/x86/boot/bzImage -initrd ~/src/initramfs.cpio.gz 
-nographic -append "console=ttyS0" -enable-kvm "$@"
$

I build podman image named "kmsan" using non-root user:
$ podman build -f kmsan.Dockerfile -t kmsan .

And run it using same non-root user and privileged podman container:
$ podman run -it --rm --privileged kmsan

And inside podman container I execute qemu.sh script:
$ ./qemu.sh

Here's kmsan unit-test output I get:

[    4.995020]     KTAP version 1 

[    4.996924]     # Subtest: kmsan 

[    4.998461]     # module: kmsan_test 

[    4.998580]     1..25 

[    5.003992]     # test_uninit_kmalloc: uninitialized kmalloc test 
(UMR report) 

[    5.006948] *ptr is true 

[    5.008519]     # test_uninit_kmalloc: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:173
[    5.008519]     Expected report_matches(&expect) to be true, but is false
[    5.016673]     not ok 1 test_uninit_kmalloc 

[    5.019871]     # test_init_kmalloc: initialized kmalloc test (no 
reports)
[    5.022995] *ptr is false 

[    5.026736]     ok 2 test_init_kmalloc 

[    5.029653]     # test_init_kzalloc: initialized kzalloc test (no 
reports)
[    5.033060] *ptr is false 

[    5.037952]     ok 3 test_init_kzalloc 

[    5.040898]     # test_uninit_stack_var: uninitialized stack variable 
(UMR report) 

[    5.044349] cond is false 
  

[    5.045465]     # test_uninit_stack_var: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:211
[    5.045465]     Expected report_matches(&expect) to be true, but is false
[    5.052473]     not ok 4 test_uninit_stack_var 

[    5.054740]     # test_init_stack_var: initialized stack variable (no 
reports) 

[    5.061026] cond is true 

[    5.064956]     ok 5 test_init_stack_var 

[    5.067630]     # test_params: uninit passed through a function 
parameter (UMR report)
[    5.073602] arg1 is false 

[    5.074766] arg2 is false 

[    5.075939] arg is false 
  

[    5.077078] arg1 is false 

[    5.078317] arg2 is true
[    5.080043]     # test_params: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:262
[    5.080043]     Expected report_matches(&expect) to be true, but is 
false
[    5.086057]     not ok 6 test_params 

[    5.088155]     # test_uninit_multiple_params: uninitialized local 
passed to fn (UMR report)
[    5.093995] signed_sum3(a, b, c) is true
[    5.096099]     # test_uninit_multiple_params: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:282
[    5.096099]     Expected report_matches(&expect) to be true, but is false
[    5.107367]     not ok 7 test_uninit_multiple_params
[    5.110155]     # test_uninit_kmsan_check_memory: 
kmsan_check_memory() called on uninit local (UMR report)
[    5.116984]     # test_uninit_kmsan_check_memory: EXPECTATION FAILED 
at mm/kmsan/kmsan_test.c:309
[    5.116984]     Expected report_matches(&expect) to be true, but is false
[    5.126356]     not ok 8 test_uninit_kmsan_check_memory
[    5.128587]     # test_init_kmsan_vmap_vunmap: pages initialized via 
vmap (no reports)
[    5.137961]     ok 9 test_init_kmsan_vmap_vunmap
[    5.140564]     # test_init_vmalloc: vmalloc buffer can be 
initialized (no reports)
[    5.145685] buf[0] is true
[    5.151173]     ok 10 test_init_vmalloc
[    5.154140]     # test_uaf: use-after-free in kmalloc-ed buffer (UMR 
report)
[    5.157541] value is true
[    5.158726]     # test_uaf: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:378
[    5.158726]     Expected report_matches(&expect) to be true, but is false
[    5.165473]     not ok 11 test_uaf
[    5.167650]     # test_percpu_propagate: uninit local stored to 
per_cpu memory (UMR report)
[    5.173084] check is false
[    5.174605]     # test_percpu_propagate: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:396
[    5.174605]     Expected report_matches(&expect) to be true, but is false
[    5.183281]     not ok 12 test_percpu_propagate
[    5.185632]     # test_printk: uninit local passed to pr_info() (UMR 
report)
[    5.191356] ffff9d1b00367cec contains 0
[    5.193590]     # test_printk: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:418
[    5.193590]     Expected report_matches(&expect) to be true, but is false
[    5.200144]     not ok 13 test_printk
[    5.202139]     # test_init_memcpy: memcpy()ing aligned initialized 
src to aligned dst (no reports)
[    5.208531]     ok 14 test_init_memcpy
[    5.210437]     # test_memcpy_aligned_to_aligned: memcpy()ing aligned 
uninit src to aligned dst (UMR report)
[    5.216716]     # test_memcpy_aligned_to_aligned: EXPECTATION FAILED 
at mm/kmsan/kmsan_test.c:459
[    5.216716]     Expected report_matches(&expect) to be true, but is false
[    5.225432]     not ok 15 test_memcpy_aligned_to_aligned
[    5.227044]     # test_memcpy_aligned_to_unaligned: memcpy()ing 
aligned uninit src to unaligned dst (UMR report)
[    5.231774]     # test_memcpy_aligned_to_unaligned: EXPECTATION 
FAILED at mm/kmsan/kmsan_test.c:483
[    5.231774]     Expected report_matches(&expect) to be true, but is false
[    5.236286]     # test_memcpy_aligned_to_unaligned: EXPECTATION 
FAILED at mm/kmsan/kmsan_test.c:486
[    5.236286]     Expected report_matches(&expect) to be true, but is false
[    5.242427]     not ok 16 test_memcpy_aligned_to_unaligned
[    5.244753]     # test_memcpy_initialized_gap: unaligned 4-byte 
initialized value gets a nonzero origin after memcpy() - (2 UMR reports)
[    5.248626]     # test_memcpy_initialized_gap: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:532
[    5.248626]     Expected report_matches(&expect) to be true, but is false
[    5.252339]     # test_memcpy_initialized_gap: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:538
[    5.252339]     Expected report_matches(&expect) to be true, but is false
[    5.258704]     not ok 17 test_memcpy_initialized_gap
[    5.261660]     # test_memset16: memset16() should initialize memory
[    5.268995]     ok 18 test_memset16
[    5.270905]     # test_memset32: memset32() should initialize memory
[    5.275684]     ok 19 test_memset32
[    5.278033]     # test_memset64: memset64() should initialize memory
[    5.283358]     ok 20 test_memset64
[    5.285848]     # test_memset_on_guarded_buffer: memset() on ends of 
guarded buffer should not crash
[    5.292876]     ok 21 test_memset_on_guarded_buffer
[    5.295048]     # test_long_origin_chain: origin chain exceeding 
KMSAN_MAX_ORIGIN_DEPTH (UMR report)
[    5.299320]     # test_long_origin_chain: EXPECTATION FAILED at 
mm/kmsan/kmsan_test.c:599
[    5.299320]     Expected report_matches(&expect) to be true, but is false
[    5.306978]     not ok 22 test_long_origin_chain
[    5.310383]     # test_stackdepot_roundtrip: testing stackdepot 
roundtrip (no reports)
[    5.317344]  kunit_try_run_case+0x19b/0xa00
[    5.319610]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    5.322374]  kthread+0x89f/0xb20
[    5.324121]  ret_from_fork+0x182/0x2a0
[    5.326284]  ret_from_fork_asm+0x1a/0x30
[    5.330550]     ok 23 test_stackdepot_roundtrip
[    5.333135]     # test_unpoison_memory: unpoisoning via the 
instrumentation vs. kmsan_unpoison_memory() (2 UMR reports)
[    5.340187] =====================================================
[    5.342896] BUG: KMSAN: uninit-value in test_unpoison_memory+0x146/0x3f0
[    5.345803]  test_unpoison_memory+0x146/0x3f0
[    5.347698]  kunit_try_run_case+0x19b/0xa00
[    5.348883]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    5.350393]  kthread+0x89f/0xb20
[    5.351322]  ret_from_fork+0x182/0x2a0
[    5.352454]  ret_from_fork_asm+0x1a/0x30
[    5.353527]
[    5.353917] Local variable a created at:
[    5.354968]  test_unpoison_memory+0x40/0x3f0
[    5.356253]
[    5.356716] Bytes 0-2 of 3 are uninitialized
[    5.357896] Memory access of size 3 starts at ffff9d1b003f7ced
[    5.359104]
[    5.359473] CPU: 3 UID: 0 PID: 121 Comm: kunit_try_catch Tainted: G 
               N  6.17.0 #1 PREEMPT(voluntary)
[    5.361551] Tainted: [N]=TEST
[    5.362147] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.17.0-5.fc42 04/01/2014
[    5.363915] =====================================================
[    5.365146] Disabling lock debugging due to kernel taint
[    5.366264] =====================================================
[    5.367559] BUG: KMSAN: uninit-value in test_unpoison_memory+0x23d/0x3f0
[    5.368626]  test_unpoison_memory+0x23d/0x3f0
[    5.369292]  kunit_try_run_case+0x19b/0xa00
[    5.369938]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    5.370768]  kthread+0x89f/0xb20
[    5.371299]  ret_from_fork+0x182/0x2a0
[    5.371862]  ret_from_fork_asm+0x1a/0x30
[    5.372478]
[    5.372695] Local variable b created at:
[    5.373302]  test_unpoison_memory+0x56/0x3f0
[    5.373896]
[    5.374097] Bytes 0-2 of 3 are uninitialized
[    5.374714] Memory access of size 3 starts at ffff9d1b003f7ce9
[    5.375536]
[    5.375771] CPU: 3 UID: 0 PID: 121 Comm: kunit_try_catch Tainted: G 
  B            N  6.17.0 #1 PREEMPT(voluntary)
[    5.377209] Tainted: [B]=BAD_PAGE, [N]=TEST
[    5.377771] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.17.0-5.fc42 04/01/2014
[    5.378816] =====================================================
[    5.382141]     ok 24 test_unpoison_memory
[    5.384615]     # test_copy_from_kernel_nofault: testing 
copy_from_kernel_nofault with uninitialized memory
[    5.389317] =====================================================
[    5.391106] BUG: KMSAN: uninit-value in 
copy_from_kernel_nofault+0x216/0x4b0
[    5.393125]  copy_from_kernel_nofault+0x216/0x4b0
[    5.394564]  test_copy_from_kernel_nofault+0x146/0x2c0
[    5.396107]  kunit_try_run_case+0x19b/0xa00
[    5.397331]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    5.398582]  kthread+0x89f/0xb20
[    5.399282]  ret_from_fork+0x182/0x2a0
[    5.400070]  ret_from_fork_asm+0x1a/0x30
[    5.400912]
[    5.401260] Local variable src created at:
[    5.402081]  test_copy_from_kernel_nofault+0x56/0x2c0
[    5.403139]
[    5.403525] Bytes 0-3 of 4 are uninitialized
[    5.404396] Memory access of size 4 starts at ffff9d1b00407ce8
[    5.405579]
[    5.405914] CPU: 0 UID: 0 PID: 123 Comm: kunit_try_catch Tainted: G 
  B            N  6.17.0 #1 PREEMPT(voluntary)
[    5.407990] Tainted: [B]=BAD_PAGE, [N]=TEST
[    5.408620] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.17.0-5.fc42 04/01/2014
[    5.409904] =====================================================
[    5.410823] ret is false
[    5.411962]     ok 25 test_copy_from_kernel_nofault
[    5.426479] # kmsan: pass:13 fail:12 skip:0 total:25
[    5.427361] # Totals: pass:13 fail:12 skip:0 total:25
[    5.428300] not ok 1 kmsan

I've debugged it, and as I previously wrote, the cause is stack depots 
not being allocated when kmsan kmalloc hook is called. Previously sent 
patch fixes these unit-test failures for me.

> 
> Please explain how you're triggering this failure and whether you think
> we should backport the fix into -stable kernels and if so, are you able
> to identify a suitable Fixes: target?
> 
At the moment I don't think any backporting is needed.

> Thanks.

Kind regards,
Aleksei Nikiforov

