Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96452CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE51B8E0003; Fri, 26 Sep 2025 12:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93FA8E0001; Fri, 26 Sep 2025 12:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84328E0003; Fri, 26 Sep 2025 12:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91EF28E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:03:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 495AB160713
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:03:13 +0000 (UTC)
X-FDA: 83931870666.28.DC56B2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FF8E4000F
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:03:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TEyDuCPA;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758902591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hhk4g3pMCBUkgSmFRN6oV+f6rC/Eax9hEYNlh9vzlA=;
	b=K72phzrd5lPy0Zj3YjG84iU08B36GITU2TviTgQs/EH9W2NuEFwEwyf74i9B12xEJaT8H2
	iKpL1ujJpHxCysb/3pYpFFFeMQWXWaAPnem4OyzfQDp6a+ef5GXCur/+e4EG88J8yDtNIo
	9cwJ2xYvCth1WR4DGTiOazpW+QgJuuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758902591; a=rsa-sha256;
	cv=none;
	b=GxUvAicDzdts5ITKRICSsy8z2M5m6SBCquYW66SYG/0DxSodCmZ72/1ZZeGo2y4h9+S5cp
	1HiJ4EKdOVoUi5VIVoTSzUC6209N4O7vqCyXwqOXI4f3IAnBHAaEwnIaulpHBMYO8laF7u
	DSz3rk9ewUlOzhoV/DwhonlInd9PmBg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TEyDuCPA;
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758902590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5hhk4g3pMCBUkgSmFRN6oV+f6rC/Eax9hEYNlh9vzlA=;
	b=TEyDuCPA7yK0ZvX4fEJNrwEWIeJIyVj/MteeMCp/B7RqvFYn6Rnyms2E5+9CwDnxQRySRt
	M0Trsanb59vlK+j4LRVZ+P3oCLKH2cuJko9ZCi70zLb6fOavoe9hEIlLAspTB8YlecRfnY
	28ooBieDAbWNfLlUIZQ/5fpoLLLgkYQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-YrvlJl-xNdO8p7c4LyoB9w-1; Fri,
 26 Sep 2025 12:03:07 -0400
X-MC-Unique: YrvlJl-xNdO8p7c4LyoB9w-1
X-Mimecast-MFC-AGG-ID: YrvlJl-xNdO8p7c4LyoB9w_1758902585
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5118919560B8;
	Fri, 26 Sep 2025 16:03:04 +0000 (UTC)
Received: from localhost (unknown [10.72.112.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FB291800446;
	Fri, 26 Sep 2025 16:03:02 +0000 (UTC)
Date: Sat, 27 Sep 2025 00:02:57 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v2 0/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <aNa5MeqWNJW0afW9@fedora>
References: <20250926155504.5122-1-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250926155504.5122-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9rHmz6HhAVCDVJ5Jy-C_2DZ7vbvdnbwxdsaUMyQolmE_1758902585
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="8LSFryOhW8E4K7ok"
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FF8E4000F
X-Stat-Signature: rm9j79ksmstmns6jgqnp937rhqxute9c
X-Rspam-User: 
X-HE-Tag: 1758902591-899046
X-HE-Meta: U2FsdGVkX19m1x5sEZljIW5O/UVEs8xKuIsStB4kBjbWfA4AiB8+Nre81MiQNz8LmLLa0hC6NH1yC3RkPSOP2hyxBlacsCQvKUhOSxh86IB1nxPwd0CJmNJlgjp/KXkzCBRYoHkzsOCMyqtjFZSaylyKt0yUG9nUd9fBKQ6q+ILsPI0ihjbQ7Hp2foMFz5K8l5jgoVc3XMO0KoDDrxGIEmkKtE/CXu2eSS1x8P3iIqAVN0k7SU0z0Pax75HrOVvD+gbr9u5HM5JuGIv/Gx/ifzCLYgCGJi1F6Tuf6xvDZbqy4g9cxA03piGbR2tbCCcE9a9vo6T/otx6WF9IAny1DIDh5px8NgjZf8MtlPvxpTpr2IWlbJUde7WCSv4y+jCQaAkFBZj2n1LtGezOPUDOEtgdBxt4PC+e39uv+jaDOkXyfXTgOah+ZGZz6HJJ2wS9MGEfRgePEluhu4WaZP4/0ZxV/3WO4bhkgjvwDVdvbGiGhVnLicCYo24b7rz4E3t6P4MHtWlG7JCPYYOU5vZUat3mWnibkNoV4JFT2QGGdMDKHiwM77v9u2ZwOu/p/UwnBzyf/Xpi6mOIggS2YrzWA4Xrs74bXSfbe/zMq4yGc9t9eLRCIdhus8P3aSlvqTLD4/89KrEUH9XIQMUZgRQ+VrPPknygSd/pIdkTvZ2s+jbqToyRK9+qrNFx6rmSoHVaJfHSA1tyqVX1LC4rNfuSFMYW8EQEkyTnS63IHUAF841BLSq0OWbo2mFh5WIM268XneDnqPDgmP3ff8/8SxTN71JzqOJ6xg99HZfOVR2EZjcXIIIwWjsltHW2LA/cBG24+OY/4F8k501NrlQplJ9mmyNnWB9IEEEt/bN7kE7ba6KVNGGQkrPoR1nd/RceFNuyu73zHvnlrgClMNnvRk0Xy7y24lc1VI2zcb890DQ4sAFUpM+n7C5ttNhaOiccf+gC6WYc2eebIcLP4gvBZeZ
 PaP3aJqR
 jzQXkSRpSQqcq1IVvP/p1yG7BeQjLCZd53H7zeCLyS7mwnW+8mM+fYm6D0NHbiSJk8JG/c6LIswtDchUnbX6hsND1uwsnSuJ2dxUgslbUQVsp1Qo3rP4jNPVXGlt5BkBXZQBz6/1/EASZoUpVVxlaAZJkXKcJ9PORH+LhUpmcYzCbT8a9bMOEBj0jPg4h0VU3BpLj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--8LSFryOhW8E4K7ok
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 09/26/25 at 11:55pm, Baoquan He wrote:
> The detailed information about patch can be found in patch log. Here I
> would like to add testing related information.
> 
>  On my system, it has 8 nodes, 64G RAM. So I created 4 zram devices of
> size 16G. Doing this because I can't find system with 4 free SSD disk
> which can be used as swap devices. And nowadays, swap, zram become more
> and more popular, even default setup, so I create zram to test patch.
> # free -h
>                total        used        free      shared  buff/cache   available
> Mem:            62Gi       1.6Gi        61Gi       4.8Mi       276Mi        61Gi
> Swap:           63Gi          0B        63Gi
> 
> 1) create zram
> #My fedora will add one zram0 by default, I reset it because the zram size if not enough
> swapoff /dev/zram0 
> 
> cd /sys/block/
> echo 1 > zram0/reset
> cat /sys/class/zram-control/hot_add
> cat /sys/class/zram-control/hot_add
> cat /sys/class/zram-control/hot_add
>  
> echo 16G > zram0/disksize 
> echo 16G > zram1/disksize 
> echo 16G > zram2/disksize
> echo 16G > zram3/disksize 
>  
> mkswap /dev/zram0
> mkswap /dev/zram1
> mkswap /dev/zram2
> mkswap /dev/zram3
>  
> swapon /dev/zram0
> swapon /dev/zram1
> swapon /dev/zram2
> swapon /dev/zram3
> 
> 2) Create memcg with 4G (this avoids noise from other anon process in system)
> cd /sys/fs/cgroup/
> mkdir testing
> echo 4G > testing/memory.max
> echo 3G > testing/memory.high
> 
> 3) Run usemem in memcg
> cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt
> 
> The usemem output is not easy to understand, I will attach my draft
> script in thread for easing result collecting and statistics.

1)
Yon can fetch usemem from here:
https://kernel.googlesource.com/pub/scm/linux/kernel/git/wfg/vm-scalability

2) In attachments, usemem-calc.sh is used to analyze raw data from
usemem output, then output an unstandable result. You can copy below
commands to run ten times or how many times you want on usemem.

for i in {1..10}; do
    cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt
    ~/usemem-calc.sh ~/vm-scalability/temp.txt
    echo "The $i""th time to run usemem" 
done

3) Please keep all the output of usemem-calc.sh to a file, then use
result.sh to get an average value.

Any unclear part, please feel free to ask me privately or publicly in
thread.

Thanks
Baoquan

--8LSFryOhW8E4K7ok
Content-Type: application/x-sh
Content-Disposition: attachment; filename="usemem-calc.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0A# =E5=8F=82=E6=95=B0=E6=A3=80=E6=9F=A5=0Aif [ $# -ne 1 ]; th=
en=0A    echo "Usage: $0 <data_file>"=0A    exit 1=0Afi=0A=0Ainput_file=3D$=
1=0A=0A# =E6=96=87=E4=BB=B6=E5=AD=98=E5=9C=A8=E6=80=A7=E6=A3=80=E6=9F=A5=0A=
if [ ! -f "$input_file" ]; then=0A    echo "Error: File '$input_file' not f=
ound!"=0A    exit 1=0Afi=0A=0A# =E5=88=9D=E5=A7=8B=E5=8C=96=E7=BB=9F=E8=AE=
=A1=E5=8F=98=E9=87=8F=0Atotal=3D0=0Atime=3D0=0Afree=3D0=0Asingle_throughput=
=3D0=0Asingle_free=3D0=0Anum=3D0=0A=0Awhile read -r line; do=0A    bytes=3D=
$(echo "$line" | awk '{print $2}')=0A    if [[ "$bytes" =3D=3D *"bytes"* ]]=
; then=0A        # =E4=BD=BF=E7=94=A8awk=E6=8F=90=E5=8F=96=E4=B8=89=E4=B8=
=AA=E6=95=B0=E5=AD=97=0A        bytes=3D$(echo "$line" | awk '{print $1}')=
=0A        usecs=3D$(echo "$line" | awk '{print $4}')=0A        kbs=3D$(ech=
o "$line" | awk '{print $7}')=0A       =20=0A        total=3D$((total + kbs=
))=0A        time=3D$((time + usecs))=0A        num=3D$((num + 1))=0A      =
  # =E8=BE=93=E5=87=BA=E7=BB=93=E6=9E=9C=0A        #echo "Bytes: $bytes, Mi=
croseconds: $usecs, KB/s: $kbs"=0A    elif [[ "$bytes" =3D=3D *"usecs"* ]];=
 then=0A        usecs=3D$(echo "$line" | awk '{print $1}')=0A        free=
=3D$((free + usecs))=0A        #echo "free Microseconds: $usecs"=0A    fi=
=0A       =20=0Adone < "$input_file"=0A=0Aecho $num=0Atime=3D$(echo "scale=
=3D2; $time / 1000000" | bc)=0Atotal=3D$(echo "scale=3D2; $total / 1024" | =
bc)=0Asingle_throughput=3D$(echo "scale=3D2; $total / $num" | bc)=0Asingle_=
free=3D$(echo "scale=3D2; $free / $num" | bc)=0A=0Aecho "System time:      =
         $time" "s"=0Aecho "Sum Throughput:            $total" "MB/s"=0Aech=
o "Single process Throughput: $single_throughput" "MB/s"=0Aecho "free laten=
cy:              $single_free" "us"=0A
--8LSFryOhW8E4K7ok
Content-Type: application/x-sh
Content-Disposition: attachment; filename="result.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0Aif [ $# -ne 1 ]; then=0A    echo "Usage: $0 <data_file>"=0A =
   exit 1=0Afi=0A=0Ainput_file=3D$1=0A=0Aif [ ! -f "$input_file" ]; then=0A=
    echo "Error: File '$input_file' not found!"=0A    exit 1=0Afi=0A=0Ast=
=3D0=0Asum=3D0=0Asingle=3D0=0Afree=3D0=0Anum=3D0=0A=0Awhile read -r line; d=
o=0A    name=3D$(echo "$line" | awk '{print $1}')=0A    if [[ "$name" =3D=
=3D *"System"* ]]; then=0A        decimal_num=3D$(echo "$line" | grep -Eo '=
[0-9]*\.[0-9]+')=0A        st=3D$(echo "scale=3D2; $st + $decimal_num" | bc=
)=0A        num=3D$((num + 1))=0A        #echo "$num"=0A        #echo "Byte=
s: $bytes, Microseconds: $usecs, KB/s: $kbs"=0A    elif [[ "$name" =3D=3D *=
"Sum"* ]]; then=0A        decimal_num=3D$(echo "$line" | grep -Eo '[0-9]*\.=
[0-9]+')=0A        sum=3D$(echo "scale=3D2; $sum + $decimal_num" | bc)=0A  =
      #sum=3D$((sum + name))=0A        #echo "$sum"=0A        #echo "free M=
icroseconds: $usecs"=0A    elif [[ "$name" =3D=3D *"Single"* ]]; then=0A   =
     decimal_num=3D$(echo "$line" | grep -Eo '[0-9]*\.[0-9]+')=0A        si=
ngle=3D$(echo "scale=3D2; $single + $decimal_num" | bc)=0A        #echo "$s=
ingle"=0A    elif [[ "$name" =3D=3D *"free"* ]]; then=0A        decimal_num=
=3D$(echo "$line" | grep -Eo '[0-9]*\.[0-9]+')=0A        free=3D$(echo "sca=
le=3D2; $free + $decimal_num" | bc)=0A        #free=3D$((free + name))=0A  =
      #echo "$free"=0A    fi=0A       =20=0Adone < "$input_file"=0A=0A#echo=
 $num=0Ast=3D$(echo "scale=3D2; $st / $num" | bc)=0Asum=3D$(echo "scale=3D2=
; $sum / $num" | bc)=0Asingle=3D$(echo "scale=3D2; $single / $num" | bc)=0A=
free=3D$(echo "scale=3D2; $free / $num" | bc)=0A#=0Aecho "System time:     =
          $st" "s"=0Aecho "Sum Throughput:            $sum" "MB/s"=0Aecho "=
Single process Throughput: $single" "MB/s"=0Aecho "free latency:           =
   $free" "us"=0A
--8LSFryOhW8E4K7ok--


