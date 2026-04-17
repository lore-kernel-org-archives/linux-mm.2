Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA5CF8E4A0
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC646B0005; Thu, 16 Apr 2026 22:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD936B0089; Thu, 16 Apr 2026 22:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA19F6B008A; Thu, 16 Apr 2026 22:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9EA56B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:55:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 697E51B8F66
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:55:30 +0000 (UTC)
X-FDA: 84666532020.13.205942D
Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id AED67140004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:55:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=bwAfPe++;
	spf=pass (imf23.hostedemail.com: domain of wangxinyu19@lixiang.com designates 209.127.231.55 as permitted sender) smtp.mailfrom=wangxinyu19@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776394528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pl/AqeMZCy6xhiRA68A+x0yieaEItk9bBl4qRAFiWn0=;
	b=Vl5smkr3hAHgdvwAN1giHbViwDmR8l4to/Q/TE9qongN10BHSTm1WsstsIoi8T0wsLLXVG
	O7RQB9WM5eZTHk8sl34YMdKBfjFp/Bq8FfOYdJhxt31foj8h8CFrE2ALspR6LTaG8GD3//
	FavnZbSebFsVUJjsb+ntPP8bWOf+zoU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776394528; a=rsa-sha256;
	cv=none;
	b=bxGXEZsq4HeXhyXLdFbMZsQpuvTYI8uM1MgBBXwtnxAzPv2t8kTnACGQ3VE6ZlhS7cdzju
	iQORuC1HsWKb1DHH7PhTys5gckh7vYnM2c0n4fcvNY5Xui7qqyiYGc5fQp2uldxTtpf30O
	ZzBZEh2sb7BwSbGN20UlepDlDiK5e+0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=bwAfPe++;
	spf=pass (imf23.hostedemail.com: domain of wangxinyu19@lixiang.com designates 209.127.231.55 as permitted sender) smtp.mailfrom=wangxinyu19@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lixiang-com.20200927.dkim.feishu.cn; t=1776394522;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Pl/AqeMZCy6xhiRA68A+x0yieaEItk9bBl4qRAFiWn0=;
 b=bwAfPe++iTQdFmqVEwt7UyKvunHGJPcsrKBXcpGuOdu1yVc5NlBD7Qm1AnccnUcBmz7AWh
 IerALEAZQ2ZFnZS/bTOem6nqALHNcKe/v19JMPuODHuuGvvmTvAHcWEAzS1t4ZeGRhHHVK
 9XGUMUNQMsxV80PPL8dQO0qjpkfV6Querv9z6KLw4S27nws2xP2tg+M8zmcbA7oGYZWPxn
 TP7oHdEiJxl5NcK4Adguo1lAJR8blGG0zOJKjUB2UgSeBL4xYFgZFQNlzc8RM+A35WMz99
 pKRJGMNfa5hONflCV++u5E5zZhA8vEyI9GVuSDw05WHKC5KNolW4uxF0r1hPuw==
From: "wangxinyu19" <wangxinyu19@lixiang.com>
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
Content-Type: multipart/alternative;
 boundary=a0ce2c49cb7694cf11f37d1593bb524a83c0ce2fb7b8f4604bb283a368d5
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
Message-Id: <20260417025517.2972953-1-wangxinyu19@lixiang.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269e1a118+ee7d3d+kvack.org+wangxinyu19@lixiang.com>
X-Mailer: git-send-email 2.25.1
Received: from PC-4CV553FH2H.company.local ([219.143.13.73]) by smtp.feishu.cn with ESMTPS; Fri, 17 Apr 2026 10:55:19 +0800
To: <devnull+kasong.tencent.com@kernel.org>
Cc: <akpm@linux-foundation.org>, <axelrasmussen@google.com>, 
	<baohua@kernel.org>, <baolin.wang@linux.alibaba.com>, 
	<chenridong@huaweicloud.com>, <chrisl@kernel.org>, <david@kernel.org>, 
	<hannes@cmpxchg.org>, <kaleshsingh@google.com>, <kasong@tencent.com>, 
	<laoar.shao@gmail.com>, <lenohou@gmail.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>, 
	<mhocko@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>, 
	<stevensd@google.com>, <surenb@google.com>, <vernon2gm@gmail.com>, 
	<wangzicheng@honor.com>, <weixugc@google.com>, <yuanchu@google.com>, 
	<yuzhao@google.com>, <zhengqi.arch@bytedance.com>
Date: Fri, 17 Apr 2026 10:55:17 +0800
X-Original-From: wangxinyu19 <wangxinyu19@lixiang.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
X-Rspamd-Queue-Id: AED67140004
X-Rspamd-Server: rspam07
X-Stat-Signature: itf3qc5o8sramo89446bk1167qh4tjkh
X-Rspam-User: 
X-HE-Tag: 1776394527-456299
X-HE-Meta: U2FsdGVkX19z1kliGvYowhs9emDry0Jd1tcFxsww18iuuuYtJ3UVcqrVfME1HTAPkdiTGhi1EjWw1XHoEZRt9FM7l85ckqgLJTyHLPjIgXW2Qi5FsJPwwW3BRnqiFidAAO7vhF2Je8kitGjF/RUd2JFYAth6SIFkyXlXxldafzDO/4w3tDnsipxNRVGcjPIO1tLHyAbb1Jy4/8+rZ7eqcoq2TeU7LRt76+dmZ0ppaVrZ5KyuMCsIzcvI4j8iD2gjeOFTneGo9AhhkGEJkSjgtahTyYwofSw7kV6qyWi3CXXzqiDVyO8Yg+X4nygSqt9AdzTt7qvAx6IQqeJNCf2rpVLQ76fObpspMDWmRE/r8n99v1M8TEFrXxDMm4ZO3aBId1gQbFxxg9Kp+CWVEuvm7+QDAVrU7sje9KM6FJtQc7zc7vNnAqaeIzeuX2ULHtp1Fx3pWCrxguWScXoVDQYyi8+DIJntnX8O9BQsCha6RTcJQ7itBeWMScxfkGit8eRA5OAjXHLamiQtyv6ZO8TMhnrl8U/RbYwiiIBtAgvQ7TRBFUt4Bgy2sso5BvEG+h+mcb3Nhx+wm0CBwx6QXJQxjenfXe0upx5euJAdJL7/BGxDZrG4d3jPztUHUu3NRH5X8NxGaqrvvSloXXLwX+gxvy08Z/+u0/aeEjDqJSPr6vs+x0KDo9RfX9lgTbVrnO97lH+SH7z4FdYEHVCPJAiva1143uhkR2SBqid1fN56nZROWWCS/1sac2sWCC9KKRYLw8YemXzuZMMk2iCOFwrhiusv+PWR+dNh6VVh6lLf2XV6OFe0+xLH6EN7mGtLPaCCk6wiP2Jd0y+uxvJCq7n67Rk9MRksAr+6kW0QIKSbx0g4pLfQ/FSdmJX4g9/viumqP17RvCjarw2gH+B9aF9mMuLwemi49LCDTim3/gaFUulTy/Z64BBz4FIY4WRwIEHuhfjqvp/vn6/U9twH8/+
 IdKti3ZI
 eK2ACrnSuLFcjv85Ymx4Wb4Shm5BK5XubtilY3aeKVDmkRyZsA6nVew6Lx0CXSmedWYJO65+ZrbDuSXld5PNum2hyNjssu9xUmeQV81KBH7MsWopECIEzpPTVsDpMM49oiNNaF012pcIa8J1v8B37UBm3MhoPo7l/mETXcTCJBQ4P+KOXb5rIW/LfVivFQiloJhgCn641zcIiaDX3Wpp9FC28u5anyyxNsgAQ0pZ6DnXx8ThB8TuwFoEUsCcp6mu2/XJcEqiv61cyRsCA6TKyzTtSw6vmhf8qq4HzLJER4r/X4JFhhEiBeWLVxXP0/Gg4y+JivRcxt8W9+ZF4jPQA1Mgk9DFO9xXzrHYgm0ETB3qvzaV1pLToak3Rbw8oTaOxeTYxSXeK6YaPGn9phMFo34YhKS5ZG9tFv+Ylcfy5lgsPcbSA0ik9bx/rpk8A7GAZxs6AVtIQtdaY+C7nUsqD+dYgObn1pRIzFDdaBK1ZORjnn/VPzGz33P+m/4Vl6z/7bUDjw2ZgOLTlLviVY/xCmJYYj4hwbdHEy4A6jtLr5kiAbZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--a0ce2c49cb7694cf11f37d1593bb524a83c0ce2fb7b8f4604bb283a368d5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon, 13 Apr 2026 00:48:14 +0800, Kairui Song wrote:
> This series is based on mm-unstable, also applies to mm-new.
>=20
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.
>=20
> Some of the problems were found in our production environment, and
> others were mostly exposed while stress testing during the development
> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> the code base and fixes several performance issues, preparing for
> further work.
>=20
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective.

> This series slightly cleans up and improves these issues using a scan
> budget by calculating the number of folios to scan at the beginning of
> the loop, and decouples aging from the reclaim calculation helpers.
> Then, move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
>=20
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and a 128G memory machine using NVME as storage.

Hi Kairui,

We have tested this patch series on Android device under a typical scenario=
.

The test consisted of cold-starting multiple applications sequentially
under moderate system load (some services running on the background,=20
such as map navigating, AI voice-assistant). Each test round cold-starts
a fixed set of apps one by one and records the cold start latency.
A total of 100 rounds were conducted to ensure statistical significance.

Before:
  /proc/vmstat info:
    pgpgin 269,224
    pgpgout 226,078
    workingset_refault_anon 237
    workingset_refault_file 27689

  Launch Time Summary (all apps, all runs)
    Mean 868.0ms
    P50 888.0ms
    P90 1274.2ms
    P95 1399.0ms

After:
  /proc/vmstat info:
    pgpgin 223,801                (-16.9%)
    pgpgout 308,873
    workingset_refault_anon 498
    workingset_refault_file 17075 (-38.3%)

  Launch Time Summary (all apps, all runs)
    Mean 850.5ms (-2.07%)
    P50 861.5ms  (-3.04%)
    P90 1179.0ms (-8.05%)
    P95 1228.0ms (-12.2%)
   =20
--
Best regards,
Xinyu

=E5=A3=B0=E6=98=8E=EF=BC=9A=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=B6=E5=8F=AA=E5=
=85=81=E8=AE=B8=E6=96=87=E4=BB=B6=E6=8E=A5=E6=94=B6=E8=80=85=E9=98=85=E8=AF=
=BB=EF=BC=8C=E6=9C=89=E5=BE=88=E9=AB=98=E7=9A=84=E6=9C=BA=E5=AF=86=E6=80=A7=
=E8=A6=81=E6=B1=82=E3=80=82=E7=A6=81=E6=AD=A2=E5=85=B6=E4=BB=96=E4=BA=BA=E4=
=BD=BF=E7=94=A8=E3=80=81=E6=89=93=E5=BC=80=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=
=96=E8=BD=AC=E5=8F=91=E9=87=8C=E9=9D=A2=E7=9A=84=E4=BB=BB=E4=BD=95=E5=86=85=
=E5=AE=B9=E3=80=82=E5=A6=82=E6=9E=9C=E6=9C=AC=E9=82=AE=E4=BB=B6=E9=94=99=E8=
=AF=AF=E5=9C=B0=E5=8F=91=E7=BB=99=E4=BA=86=E4=BD=A0=EF=BC=8C=E8=AF=B7=E8=81=
=94=E7=B3=BB=E9=82=AE=E4=BB=B6=E5=8F=91=E5=87=BA=E8=80=85=E5=B9=B6=E5=88=A0=
=E9=99=A4=E8=BF=99=E4=B8=AA=E6=96=87=E4=BB=B6=E3=80=82=E6=9C=BA=E5=AF=86=E5=
=8F=8A=E6=B3=95=E5=BE=8B=E7=9A=84=E7=89=B9=E6=9D=83=E5=B9=B6=E4=B8=8D=E5=9B=
=A0=E4=B8=BA=E8=AF=AF=E5=8F=91=E9=82=AE=E4=BB=B6=E8=80=8C=E6=94=BE=E5=BC=83=
=E6=88=96=E4=B8=A7=E5=A4=B1=E3=80=82=E4=BB=BB=E4=BD=95=E6=8F=90=E5=87=BA=E7=
=9A=84=E8=A7=82=E7=82=B9=E6=88=96=E6=84=8F=E8=A7=81=E5=8F=AA=E5=B1=9E=E4=BA=
=8E=E4=BD=9C=E8=80=85=E7=9A=84=E4=B8=AA=E4=BA=BA=E8=A7=81=E8=A7=A3=EF=BC=8C=
=E5=B9=B6=E4=B8=8D=E4=B8=80=E5=AE=9A=E4=BB=A3=E8=A1=A8=E6=9C=AC=E5=85=AC=E5=
=8F=B8=E3=80=82
Disclaimer: This email is intended to be read only by the designated recipi=
ent of the document and has high confidentiality requirements. Anyone else =
is prohibited from using, opening, copying or forwarding any of the content=
s inside. If this email was sent to you by mistake, please contact the send=
er of the email and delete this file immediately. Confidentiality and legal=
 privileges are not waived or lost by misdirected emails. Any views or opin=
ions expressed in the email are those of the author and do not necessarily =
represent those of the Company.


--a0ce2c49cb7694cf11f37d1593bb524a83c0ce2fb7b8f4604bb283a368d5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<p>On Mon, 13 Apr 2026 00:48:14 +0800, Kairui Song wrote:
<br>> This series is based on mm-unstable, also applies to mm-new.
<br>>=20
<br>> This series cleans up and slightly improves MGLRU's reclaim loop and
<br>> dirty writeback handling. As a result, we can see an up to ~30% incre=
ase
<br>> in some workloads like MongoDB with YCSB and a huge decrease in file
<br>> refault, no swap involved. Other common benchmarks have no regression=
,
<br>> and LOC is reduced, with less unexpected OOM, too.
<br>>=20
<br>> Some of the problems were found in our production environment, and
<br>> others were mostly exposed while stress testing during the developmen=
t
<br>> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
<br>> the code base and fixes several performance issues, preparing for
<br>> further work.
<br>>=20
<br>> MGLRU's reclaim loop is a bit complex, and hence these problems are
<br>> somehow related to each other. The aging, scan number calculation, an=
d
<br>> reclaim loop are coupled together, and the dirty folio handling logic=
 is
<br>> quite different, making the reclaim loop hard to follow and the dirty
<br>> flush ineffective.
<br>
<br>> This series slightly cleans up and improves these issues using a scan
<br>> budget by calculating the number of folios to scan at the beginning o=
f
<br>> the loop, and decouples aging from the reclaim calculation helpers.
<br>> Then, move the dirty flush logic inside the reclaim loop so it can ki=
ck
<br>> in more effectively. These issues are somehow related, and this serie=
s
<br>> handles them and improves MGLRU reclaim in many ways.
<br>>=20
<br>> Test results: All tests are done on a 48c96t NUMA machine with 2 node=
s
<br>> and a 128G memory machine using NVME as storage.
<br>
<br>Hi Kairui,
<br>
<br>We have tested this patch series on Android device under a typical scen=
ario.
<br>
<br>The test consisted of cold-starting multiple applications sequentially
<br>under moderate system load (some services running on the background,=20
<br>such as map navigating, AI voice-assistant). Each test round cold-start=
s
<br>a fixed set of apps one by one and records the cold start latency.
<br>A total of 100 rounds were conducted to ensure statistical significance=
.
<br>
<br>Before:
<br>  /proc/vmstat info:
<br>    pgpgin 269,224
<br>    pgpgout 226,078
<br>    workingset_refault_anon 237
<br>    workingset_refault_file 27689
<br>
<br>  Launch Time Summary (all apps, all runs)
<br>    Mean 868.0ms
<br>    P50 888.0ms
<br>    P90 1274.2ms
<br>    P95 1399.0ms
<br>
<br>After:
<br>  /proc/vmstat info:
<br>    pgpgin 223,801                (-16.9%)
<br>    pgpgout 308,873
<br>    workingset_refault_anon 498
<br>    workingset_refault_file 17075 (-38.3%)
<br>
<br>  Launch Time Summary (all apps, all runs)
<br>    Mean 850.5ms (-2.07%)
<br>    P50 861.5ms  (-3.04%)
<br>    P90 1179.0ms (-8.05%)
<br>    P95 1228.0ms (-12.2%)
<br>   =20
<br>--
<br>Best regards,
<br>Xinyu</p><meta data-version=3D"editor_version_1.2.12"/><div data-zone-i=
d=3D"0" data-line-index=3D"0" data-line=3D"true" style=3D"white-space: pre-=
wrap; margin-top: 4px; margin-bottom: 4px; line-height: 1.6;"><br></div><di=
v data-zone-id=3D"0" data-line-index=3D"1" data-line=3D"true" style=3D"whit=
e-space: pre-wrap; margin-top: 4px; margin-bottom: 4px; line-height: 1.6;">=
<div style=3D"text-align: left;"><span style=3D"font-size: 12px;"><span sty=
le=3D"font-family: helvetica;"><span style=3D"color: rgb(143, 149, 158);">=
=E5=A3=B0=E6=98=8E=EF=BC=9A=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=B6=E5=8F=AA=E5=
=85=81=E8=AE=B8=E6=96=87=E4=BB=B6=E6=8E=A5=E6=94=B6=E8=80=85=E9=98=85=E8=AF=
=BB=EF=BC=8C=E6=9C=89=E5=BE=88=E9=AB=98=E7=9A=84=E6=9C=BA=E5=AF=86=E6=80=A7=
=E8=A6=81=E6=B1=82=E3=80=82=E7=A6=81=E6=AD=A2=E5=85=B6=E4=BB=96=E4=BA=BA=E4=
=BD=BF=E7=94=A8=E3=80=81=E6=89=93=E5=BC=80=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=
=96=E8=BD=AC=E5=8F=91=E9=87=8C=E9=9D=A2=E7=9A=84=E4=BB=BB=E4=BD=95=E5=86=85=
=E5=AE=B9=E3=80=82=E5=A6=82=E6=9E=9C=E6=9C=AC=E9=82=AE=E4=BB=B6=E9=94=99=E8=
=AF=AF=E5=9C=B0=E5=8F=91=E7=BB=99=E4=BA=86=E4=BD=A0=EF=BC=8C=E8=AF=B7=E8=81=
=94=E7=B3=BB=E9=82=AE=E4=BB=B6=E5=8F=91=E5=87=BA=E8=80=85=E5=B9=B6=E5=88=A0=
=E9=99=A4=E8=BF=99=E4=B8=AA=E6=96=87=E4=BB=B6=E3=80=82=E6=9C=BA=E5=AF=86=E5=
=8F=8A=E6=B3=95=E5=BE=8B=E7=9A=84=E7=89=B9=E6=9D=83=E5=B9=B6=E4=B8=8D=E5=9B=
=A0=E4=B8=BA=E8=AF=AF=E5=8F=91=E9=82=AE=E4=BB=B6=E8=80=8C=E6=94=BE=E5=BC=83=
=E6=88=96=E4=B8=A7=E5=A4=B1=E3=80=82=E4=BB=BB=E4=BD=95=E6=8F=90=E5=87=BA=E7=
=9A=84=E8=A7=82=E7=82=B9=E6=88=96=E6=84=8F=E8=A7=81=E5=8F=AA=E5=B1=9E=E4=BA=
=8E=E4=BD=9C=E8=80=85=E7=9A=84=E4=B8=AA=E4=BA=BA=E8=A7=81=E8=A7=A3=EF=BC=8C=
=E5=B9=B6=E4=B8=8D=E4=B8=80=E5=AE=9A=E4=BB=A3=E8=A1=A8=E6=9C=AC=E5=85=AC=E5=
=8F=B8=E3=80=82
</span></span></span></div></div><div data-zone-id=3D"0" data-line-index=3D=
"2" data-line=3D"true" style=3D"white-space: pre-wrap; margin-top: 4px; mar=
gin-bottom: 4px; line-height: 1.6;"><div style=3D"text-align: left;"><span =
style=3D"font-size: 12px;"><span style=3D"color: rgb(143, 149, 158);">Discl=
aimer: This email is intended to be read only by the designated recipient o=
f the document and has high confidentiality requirements. Anyone else is pr=
ohibited from using, opening, copying or forwarding any of the contents ins=
ide. If this email was sent to you by mistake, please contact the sender of=
 the email and delete this file immediately. Confidentiality and legal priv=
ileges are not waived or lost by misdirected emails. Any views or opinions =
expressed in the email are those of the author and do not necessarily repre=
sent those of the Company.</span></span><span style=3D"font-size: 12px;"><s=
pan style=3D"font-family: helvetica;"><span style=3D"color: rgb(143, 149, 1=
58);">
</span></span></span></div></div><div data-zone-id=3D"0" data-line-index=3D=
"3" data-line=3D"true" style=3D"white-space: pre-wrap; margin-top: 4px; mar=
gin-bottom: 4px; line-height: 1.6;"><br></div>
--a0ce2c49cb7694cf11f37d1593bb524a83c0ce2fb7b8f4604bb283a368d5--

