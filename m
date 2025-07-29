Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DB0C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8564B6B0096; Tue, 29 Jul 2025 07:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8073A6B0099; Tue, 29 Jul 2025 07:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E226B009A; Tue, 29 Jul 2025 07:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614D56B0096
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:29:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E782E80648
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:29:53 +0000 (UTC)
X-FDA: 83717082666.30.D429B3B
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45EDBC0004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:29:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753788592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QAECQfkrR4cV3aAGE95vDLmMbEnIP3Acl9U2Jr3qdm8=;
	b=lghsKdsQwA275SGgp1eXYKeZ8bRiWSyjVByggbB+12BtTTntLNI/BbCs5o4vATjnShOiYo
	THAfACPIw2R+ZPW8BHlQhtuFSvdWgc0Z0IRusuy4I852sNmFMjNWxO+nGsYpxh3Gq9sR+o
	g9cWb7b3tu436HPhNVHy3QLyfkswm3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753788592; a=rsa-sha256;
	cv=none;
	b=LjYljMAfZW3mkCEWoOQfRcUgifQQ1Hvbji5r7cHvNaXNK1tdcO3NBZsJ4igGl9q/9srRyf
	mcb9DP2h4hhkZoPlqwDiQdjOqxfBya7zgvR35L/W41bTFcaf/sMEWRInMPOCkjETLyAfYM
	DxLGdwXFm02zFNne2/v4CpoOAdjqDoQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of billsjc@sjtu.edu.cn designates 202.120.2.237 as permitted sender) smtp.mailfrom=billsjc@sjtu.edu.cn
Received: from proxy189.sjtu.edu.cn (smtp189.sjtu.edu.cn [202.120.2.189])
	by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id 365598BAA3;
	Tue, 29 Jul 2025 19:29:46 +0800 (CST)
Received: from smtpclient.apple (unknown [202.120.40.84])
	by proxy189.sjtu.edu.cn (Postfix) with ESMTPSA id C01C53FC1C4;
	Tue, 29 Jul 2025 19:29:43 +0800 (CST)
From: "Shi, Jiacheng" <billsjc@sjtu.edu.cn>
Message-Id: <93574E04-0528-4282-B1C3-4A16D9768EA5@sjtu.edu.cn>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_8411A966-6550-4981-8543-B66DF5E56084"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [Question] About the PCP free_high heuristic
Date: Tue, 29 Jul 2025 19:29:32 +0800
In-Reply-To: <87ldo7z5a7.fsf@DESKTOP-5N7EMDA>
Cc: linux-mm@kvack.org
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
References: <212D6530-0FE8-4EA7-A599-48D71E8AFA23@sjtu.edu.cn>
 <87ldo7z5a7.fsf@DESKTOP-5N7EMDA>
X-Mailer: Apple Mail (2.3731.500.231)
X-Rspamd-Queue-Id: 45EDBC0004
X-Stat-Signature: ijrtgqrw37kiysdo5sfks8oficpgjw1o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753788590-466694
X-HE-Meta: U2FsdGVkX19Q8/Rh1SHZTruA/Zi5ZKnq93D+v+U+CC5Zg93pldpJuOICWRzBfGyvtDabp5CvKxd2PbTODXiYXYJm523xfjceXCfxmQZsY8ijNJS4P02awX51tcckm9X+ZGhNjfuZYkEKs4zSQe4DW8eySYEkojA5cFImt9uXqCrlzwF3TbEbC7AtjgmWbjijHN3azRGw4gGNPTF/NV5wk/dsn1oKhMWBTT7IpPxshAj17a0aLYKDBVxPRlDmzIaKGZkpAKtiXo/KUIGpVORAF0rWhEsD4ThIecgkONeimx5rvy/sS0uY3n93vct3UyVSjOaCqKZ2QWoiC68/S05MttYiKQVKp4KRzN3ccr1Z5ik2e2gR6H1ERtJknFfiIFSpFQvqiCZdEOiPQg5Rbpw8dgf/C+K0MfUtMVRtsJF6ZR8oQftFFZeAXR9iQuskyRhI4De4ZhJDzX42jX08e27NmQzlrSgwKy3/rRdXn2mgV/KNf1Fzuu0L87TLS/GdkEBOH/eXS7rmlkMaigTtxOmqG4heJnixRhvJBM5u0Di30pRDOL0PssfQsUYZQD7xw/2C7o/KexsGotnq7wSuGnlkbkOnp79fxB5YRtNFyQ5GyqyPke/4wqsTxc/1ygW4YB5dl0lRubVQ6kzhuNIBz1uGcgOALP1BSa6pCtNMaudliaooAJHxq63bRl9sfCiF75fq5GouARvtVry858CE652ZkxqVtDi9rz3v0sb0Bcv4tkbg8BBp7H4E9i+LQZbElw9IZTRw/XTkaPAsunlFKHVOgjrvNvbWZ8R2uBzMBPaQJFZTpl3zkgYrXlgH+bDRd4jwzTRx7ZIbtLnBVyOEd/csOXNcODMmKyeKMZ7WJnadbr0nfUNhKINcCSVvLnslwyUU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_8411A966-6550-4981-8543-B66DF5E56084
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi, Huang, Ying,

You are right. Using high_min is better when the workload is located on =
a single CCX.

By the way, I'm wondering why the free_high heuristic is only applied to
high-order pages. Would there also be cache misses if cache-hot order-0 =
pages
are not reused?

Best,
Jiacheng


> Huang, Ying <ying.huang@linux.alibaba.com> writes=EF=BC=9A
>=20
> Hi, Jiacheng,
>=20
> =E5=8F=B2=E5=98=89=E6=88=90 <billsjc@sjtu.edu.cn =
<mailto:billsjc@sjtu.edu.cn>> writes:
>=20
>> Hi,
>>=20
>> I ran the bw_unix benchmark in lmbench on my test machine (EPYC-7T83, =
32 vCPUs,
>> 64 GB of memory):
>>    bin/x86_64-linux-gnu/bw_unix -P 16
>> The bandwidth result was 30511.63 MB/s when =
percpu_pagelist_high_fraction was
>> set to 8; however, the result drops to 21595.98 MB/s when
>> percpu_pagelist_high_fraction is set to 0 (enabling PCP high =
auto-tuning).
>>=20
>> I first inspected the auto-tuning code, but the root cause of the =
performance
>> degradation lies in the triggering threshold of the free_high =
heuristic:
>>    pcp->free_count >=3D (batch + pcp->high_min / 2)
>=20
> free_high heuristic is used to increase last level (shared) cache
> hotness via letting one core allocate cache-hot pages just freed by
> another core.  The target use case is network workload.
>=20
> It appears that free_high heuristic hurts your performance.  One
> possible reason may be that the last level cache isn't always shared =
on
> AMD CPU.  Can you try to bind workload to one CCX and verify whether
> this is the root cause?
>=20
>> I noticed that commit c544a95 increases this threshold, but =
pcp->high_min is
>> relatively small when auto-tuning is enabled, and the PCP draining =
leads to
>> the performance degradation.
>>=20
>> The problem was fixed when increasing the threshold to (batch + =
pcp->high / 2).
>> Is it intended to use high_min instead of high in the threshold? =
Would it be
>> more adaptive to introduce some new tunables for the free_high =
threshold?
>=20
> In general, new knob isn't welcomed in community, because it's hard =
for
> users to tune so many knobs already.
>=20
> ---
> Best Regards,
> Huang, Ying


--Apple-Mail=_8411A966-6550-4981-8543-B66DF5E56084
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"overflow-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;"><div>Hi, =
Huang, Ying,</div><div><br></div><div>You are right. Using high_min is =
better when the workload is located on a single =
CCX.</div><div><br></div><div>By the way, I'm wondering why the =
free_high heuristic is only applied to</div><div>high-order pages. Would =
there also be cache misses if cache-hot order-0 pages</div><div>are not =
reused?</div><div><br></div><div>Best,</div><div>Jiacheng</div><div><br></=
div><div><br><blockquote type=3D"cite"><div>Huang, Ying =
&lt;ying.huang@linux.alibaba.com&gt; writes=EF=BC=9A</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Hi, Jiacheng,</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline =
!important;">=E5=8F=B2=E5=98=89=E6=88=90 &lt;</span><a =
href=3D"mailto:billsjc@sjtu.edu.cn" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">billsjc@sjtu.edu.cn</a><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">&gt; =
writes:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">Hi,<br><br>I ran the bw_unix benchmark in =
lmbench on my test machine (EPYC-7T83, 32 vCPUs,<br>64 GB of =
memory):<br>&nbsp;&nbsp;&nbsp;bin/x86_64-linux-gnu/bw_unix -P 16<br>The =
bandwidth result was 30511.63 MB/s when percpu_pagelist_high_fraction =
was<br>set to 8; however, the result drops to 21595.98 MB/s =
when<br>percpu_pagelist_high_fraction is set to 0 (enabling PCP high =
auto-tuning).<br><br>I first inspected the auto-tuning code, but the =
root cause of the performance<br>degradation lies in the triggering =
threshold of the free_high =
heuristic:<br>&nbsp;&nbsp;&nbsp;pcp-&gt;free_count &gt;=3D (batch + =
pcp-&gt;high_min / 2)<br></blockquote><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline =
!important;">free_high heuristic is used to increase last level (shared) =
cache</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;">hotness via letting one =
core allocate cache-hot pages just freed by</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">another core. &nbsp;The target use case is =
network workload.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">It =
appears that free_high heuristic hurts your performance. =
&nbsp;One</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;">possible reason may be =
that the last level cache isn't always shared on</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">AMD CPU. &nbsp;Can you try to bind workload =
to one CCX and verify whether</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">this is =
the root cause?</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">I noticed that commit c544a95 increases this =
threshold, but pcp-&gt;high_min is<br>relatively small when auto-tuning =
is enabled, and the PCP draining leads to<br>the performance =
degradation.<br><br>The problem was fixed when increasing the threshold =
to (batch + pcp-&gt;high / 2).<br>Is it intended to use high_min instead =
of high in the threshold? Would it be<br>more adaptive to introduce some =
new tunables for the free_high threshold?<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">In general, new knob isn't welcomed in =
community, because it's hard for</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">users =
to tune so many knobs already.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline =
!important;">---</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">Best =
Regards,</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;">Huang, =
Ying</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_8411A966-6550-4981-8543-B66DF5E56084--

