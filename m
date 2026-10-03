Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB0CCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 04:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7706B008A; Sat,  3 Oct 2026 00:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3711A6B008C; Sat,  3 Oct 2026 00:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239556B0092; Sat,  3 Oct 2026 00:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBAA46B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:53:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10CD12092C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:53:26 +0000 (UTC)
X-FDA: 85280096412.12.A5F7863
Received: from mail-ed2-f16.google.com (mail-ed2-f16.google.com [74.125.228.80])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A4541A0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 04:53:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OtCKWt2x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.80 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791003205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGcgHIqjPJ52+DRcO1cSQXGa066YESGqqYPcF0r2hns=;
	b=hHmc+XVJ9EV+XTSPoIHo/cbjAS5MTn/81MLeSRHJTiwX8j/5boRROm+BMb1b14guzftCKO
	v0JblfN2ecr3MH0jFMlciCikLYom7zv3/wrny4aOmQdqp42pQcgZq6QNoggRwTRIuqyVTg
	FwmvX3Uxl1RM90B564/Y/J0YtqRof+A=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OtCKWt2x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.80 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791003205;
	b=TaZ4RLVXTv0bFmS1r4qDWB2pMDZHtuX5KuHxVfXWWUBXmoi5dqcmZctNKX/5Mfq+tAwNDu
	cC2cgq50hQyGJgqfvujm24k5XAt8Vf1ecXuMhUSxuWGv7Tkvy1+wL4yg6U9nAC2UMA7iv/
	ACLNuYW85hTIjta3nX4RtuLqdsPQoiA=
Received: by mail-ed2-f16.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso243405a12.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 21:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791003204; cv=none;
        d=google.com; s=arc-20260327;
        b=j+mTbaqDMwUU4tQL+jxVOjk3e4p/qFOlwFCagZHj8GG+75VUgabtOOZVcRCC80WlJk
         n21CMao88Y7OMnHB+Q3+WWAWJgz6rI4AzZ1o2BcqDw7I14lCaldnYYLBsu+mOW1gRHvh
         r+W44BI26njkwe3kXDUwSDZbbP/Ps+zuglaqLcovK0jCZYdubriDLa5T2CLJPTVqTSp7
         RcrwFUlFMxrbsl92DD9vNMA4wuJwVW9ikgYsIwiBsBvnT1Maj8dsgChsFyL4RiyXreI+
         eAi1bRMBBxayaNkMaf2GbTvpO5z2uI5bGvY3Vz3/2yZ2iTUHdKua06EkqXvJRMBwOGCs
         5HFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eGcgHIqjPJ52+DRcO1cSQXGa066YESGqqYPcF0r2hns=;
        fh=Azi99QL4Ai11vro5NpP8S9B7gXoPDm9Z/qLWobs3Xwg=;
        b=JEUfhcD0DhbC5GZOYP808FiO0HKjqKX8ZONBcL9Bg66G/cW0TeJBBsvdStK5axB6sW
         LEpzrD3F8VlmvJxLfrjlHmlk70d8PXz+QILLGWsL73qTfO6rIFxk+fmtXbcR4I7BzOEH
         8AyfgkfXQzFlDJff6gfCCE0G+GjvHwOf0R1gdbRsW45YCbH5Npczp6EiIljsRZVGf4IQ
         R/+zIHVk9CZW7MO0l2wQYcGpw4/jRYN5jFLQIy/35rZfQO+YW6hs6hvaYLeeiCvdBTv6
         QzONyBpbxuvhu5QVNK7jhgqUtqcQgBzzFSskwJ+1qUmzMEfYHLnOlKtBpuK28JM0DQjV
         xRjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791003204; x=1791608004; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eGcgHIqjPJ52+DRcO1cSQXGa066YESGqqYPcF0r2hns=;
        b=OtCKWt2xCO1hgCYymWIcvFEWL+WTTsSYUFe74Zdog2UHxp+FrWhrtO68WfdSjEzGMR
         I58blhHlSVmoe3yBkTY93oPkWS0bQzk46/LdqPHKKOnayxh0H8iwaTO3MBaCq+htbAeX
         6grzvBujRb3AB7abcTwMJ02F7MHKlUvTjmnqRAIHSA22Q0u3fnsLwCnWO2pjsHUkczgY
         1SjSh/f6lRl9ssEX3Lf9BBcDjkGpVqkPv7ITf0aUEMu4FF97V6Sso81p5g76+/64xwoF
         jPAAAERAaBL8z3gdu8iJmbJZZZPxWazdN3FCw2EFkC1tUXl2r1L7d2zOEq+uRdDmxYqf
         Q+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791003204; x=1791608004;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eGcgHIqjPJ52+DRcO1cSQXGa066YESGqqYPcF0r2hns=;
        b=0XehQHpw4PUVeuNfozRssFL8rvb/u7RSSzWIt1ShmzRDlvx6fBUSg6aCyifVAe2od3
         2VXRUt9J2fgJlQbuTDsittA7GMjOU4ncPhsibux+sCppzP+5sWeVyv/RG6lFLClBdFcC
         fPgASrB8VLmD5Ew6ySoDKcTqTsda2XKm18WXTd+ejXRo7UKwLO+YYJS51PHvHO4ZCyVV
         5dLsbbv00/4mXhiXu36BmzLTrB+yl0LlmAdQ/Z3b2gZrzO0Vte0Ilgpfq41GrV4fQi06
         aI7sQtYlxQL6GngtniIKCjiNMuOHjUvSzHY0nmqwUhEO4oDwCQkQqIZtxvGYEOHl6wJm
         DUAg==
X-Forwarded-Encrypted: i=1; AKwUvBxUw65/RdHeIHu5R2cgYg85yls3/e0ybSydQnHKskZWMIQlZIYdCHCRlRIBZ8kTcqdrX0hw8n1Hwg==@kvack.org
X-Gm-Message-State: AFq9FYKX3+GyQa5YFlsUEB0qt3Taz8m0SWmkSy2RLwmmm4ebFD6AEAQS
	xxe+/uGqcl9+D699RtSzDuUZqYDmC800HXOk2yJL4yX19N/UdIxaNLHo8SFHou7/BvCYw8490I8
	0jx1HZbkoEPL4cIaOM4LFTKzuUdvffDM=
X-Gm-Gg: AYBFou2pGFivpLlQ1fPoYIwL4ZbypGD7zRnKPvkDnw/v8BrZ2Dlx/cungjpR7pc93lT
	CxVj6JfhL7pp1WQCQagx545lO3Fqyt3f7KD1bdtJoTvmgVrR2lIJS4A13ctu8oSPZvJYIp1z/tU
	2znRbePB2FbMDviq6YCiSNmz1hbF3tb7zyIq+Dlprw+7nb1ra0Lokvu/HLhg1PV9Jn7mMzKr5De
	vbj1SDPcd/ZE8h+Cm1GoETNf8qYosct39oQwBt4VAI9yl+mCm4PfHvI4KZy1p5IjjscZvLFRrYi
	qEFGTCuUUEoAc2WTD9AKc42rte8WneXyS2A0NegEDYjwc85BI6IP41QdTrybPNMSPVk=
X-Received: by 2002:a05:6402:4028:b0:6ac:26f0:15a1 with SMTP id
 4fb4d7f45d1cf-6af9e361d2bmr3727394a12.36.1791003203172; Fri, 02 Oct 2026
 21:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F> <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
 <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F> <CAAiJnjrjtseaUPo5vyqGZeDAt4ST6eqvaXOCWvdaTUsx2D3v5g@mail.gmail.com>
 <asAjUfNg_80sA6Yn@pedro-suse.tail5790ac.ts.net> <CAAiJnjqSMPCzO2wYg1YsUK9Nz_8Wd0R+XUxpN-YBa=3DpEMpTQ@mail.gmail.com>
In-Reply-To: <CAAiJnjqSMPCzO2wYg1YsUK9Nz_8Wd0R+XUxpN-YBa=3DpEMpTQ@mail.gmail.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sat, 3 Oct 2026 07:53:11 +0300
X-Gm-Features: AclHuK-csu_GJDwAIDAUw5RoP8HKTLZELHpTsEtC-oi_HHr3SQ-J_ww1UKxtXM0
Message-ID: <CAAiJnjoXsz_Oit1MCgf_m_HDard=cbPkLa40eKYwHfEsn=LoKw@mail.gmail.com>
Subject: Re: Poor memory bandwidth performance between NUMA nodes
To: pfalcato@suse.de
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gayi7ty5pyxn7woqw1o8xizghfxfahiw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A4541A0002
X-HE-Tag: 1791003204-450041
X-HE-Meta: U2FsdGVkX1/D1NRXqmcLzer/NFxZNb6djmJ4CA6ZgdE/xhkPt7KkgjKYmEv8LMkWSmpqLVou5jRjAzo3RwWgGY1Xru7JmKWVTa/ZnEpteODXWFpgLisWz410fvPQ+4VIce+JC9dqqouHpHlWVV4l+zF2I3keVb/fM0+JLpW8SRZNmR8oCXIz7ohV7bjWKwnGtN8BnmVbBBvflSqKRx3UMzdliIyFUB1oCKgzYzMcQ+ry6tL2db43E2x4RBmCDNkcmCj9U0AjbGmzfJgErVeNA9nG4w8vxrSezuTi0Tn0uq5qd1hqS8X1ZUStgc/XX3XEgsIcuA5S9sIzms77UWOlfTqsibpL/WQZEuy5OF3dJGVuaosVp3gOp9FNzoRXJSbQM3+QG1UcerOx61C1LgR7JKK+HtkF2im0LhPgCAooipjFOY4/RgwCjFIfFSwNbxONRuiUShxuj80dWTKbs4ABKWK07Zn1TCGDSxpI5U68wyPfKo8csu1EGqlA43NDRRCao6uwy+kYgzb7YbGUZzpYewZoCKFQT6k2zpjPgabYe4ih4CYU0fxmSTvIcpfwAY9WEuIchv10aL3N4+FbUNDfXXVTxI3hg/thEZ6N8cMIW0CSTB9z9lrhC+KQYsoKyr+BAmeM/q/6iaLVMukWhoF1IoKvtBuwiwPQXCpVXmzL2YGb5geI812/k0sRJcPDxOseF2lBNgS1/HaEuuy8eHqMyt+7DGrHNUoL36yhHp8egCbRuQ+3ofetCIeUpvCuSB0T2DF5HdAD3YfDBVfEU3BgAaSgTLw2PFst3DtkmwHQE0owVip+w9kZtqD9Bp+rv14KQo5B92jPKbULXmTgaMTW082kodv041ugEKaSXq2dmvP/6knRzsndL1JZsbAj6bkwgTdMDLKcR3QJiEGS4Wvd8WouZ/KlB3exCl2MuKXjz1qLVh91Nd0SS0T4lZgVwuADQPat69mQN/1LfhWaxY9
 FJq13T49
 caQxr1xDc4kLpspuKHWuEhqtUkeGCcgIqngQWNFjJ0bsZL1GgCgb0fIZqHD86o8F+pp0iZ+XGGa7HsC+tD8CxLTpZ+jopse3FedST6fpJpnDLl/y0IBb2Wpf7U5iKgB/IkLZaeyeU9IYSKuspPFJHlBXxDRiO4KOZCdTKlPDhXR2LjnOj5rAtNmzY6eJgDVrIuYdXARhL4LBvVJUcPm/NReqnZRStSQ/wwSxlQ7GTtjtsyrERqdOHTXHmPq2C/cvX1X/PWbntoCi7Q3Ybf3jL/jfyXu2eW+nVV6eZA+JNz5OvI6TAJLEmuQvSOaGfHU8lnvN6tXxVxOroTbnswWw2H0hokAuxp3JIWvRM3aHLflp7wJ9s5SeiJgAJ1v9JdIQqwWRKg3kHEitGqyOWRf5pFAzxSrbL/MJC/ZAHqzmZ8wM4TAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have also played with PMEM options at BIOS/UEFI, but always can't
exceed 1.4 GB/s with the same stack,

|---------------------------------------||---------------------------------=
------|
|--            System DRAM Read Throughput(MB/s):        760.92
        --|
|--           System DRAM Write Throughput(MB/s):        749.90
        --|
|--             System PMM Read Throughput(MB/s):        698.30
        --|
|--            System PMM Write Throughput(MB/s):       1397.39
        --|
|--                 System Read Throughput(MB/s):       1459.21
        --|
|--                System Write Throughput(MB/s):       2147.29
        --|
|--               System Memory Throughput(MB/s):       3606.50
        --|
|---------------------------------------||---------------------------------=
------|

Anton

=D1=81=D0=B1, 3 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 07:11, Anto=
n Gavriliuk <antosha20xx@gmail.com>:
>
> > ...are the struct pages on the pmem node itself?
>
> It was ("map":"dev")
>
> I re-created with ("map":"mem"),
>
> [root@localhost ~]# ndctl list
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"devdax",
>     "map":"mem",
>     "size":3234108276736,
>     "uuid":"3a3f75b9-0f03-4ed0-8175-4b4047d16615",
>     "chardev":"dax1.0",
>     "align":2097152
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"devdax",
>     "map":"mem",
>     "size":3234108276736,
>     "uuid":"d67528f5-0f41-4797-bff7-3b175d1cbc05",
>     "chardev":"dax0.0",
>     "align":2097152
>   }
> ]
> [root@localhost ~]# numactl -H
> available: 4 nodes (0-3)
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
> 22 23 24 25 26 27
> node 0 size: 386590 MB
> node 0 free: 336076 MB
> node 1 cpus: 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
> 47 48 49 50 51 52 53 54 55
> node 1 size: 387055 MB
> node 1 free: 337345 MB
> node 2 cpus:
> node 2 size: 3082240 MB
> node 2 free: 3082240 MB
> node 3 cpus:
> node 3 size: 3082240 MB
> node 3 free: 3082240 MB
> node distances:
> node     0    1    2    3
>    0:   10   20   25   35
>    1:   20   10   35   25
>    2:   25   35   10   20
>    3:   35   25   20   10
> [root@localhost ~]# /home/anton/Linux/mlc
> Intel(R) Memory Latency Checker - v3.13
> Measuring idle latencies for sequential access (in ns)...
>                 Numa node
> Numa node            0       1       2       3
>        0          82.4   147.0   173.8   237.5
>        1         146.9    82.7   238.8   172.3
>
> And repeated test with stress-ng,
>
> [root@localhost ~]# numactl --cpunodebind=3D0 --preferred=3D0 stress-ng
> --vm 1 --vm-bytes 300G --vm-hang 0 &
> [1] 10761
> [root@localhost ~]# stress-ng: info:  [10761] defaulting to a 1 day
> run per stressor
> stress-ng: info:  [10761] dispatching hogs: 1 vm
> stress-ng: info:  [10763] vm: using 300GB per stressor instance (total
> 300GB of 6.52TB available memory)
>
>
> [root@localhost ~]# COLUMNS=3D500 numastat -p 10764 | cat
>
> Per-node process memory usage (in MBs) for PID 10764 (stress-ng-vm)
>                            Node 0          Node 1          Node 2
>     Node 3           Total
>                   --------------- --------------- ---------------
> --------------- ---------------
> Huge                         0.00            0.00            0.00
>       0.00            0.00
> Heap                         0.06            0.00            0.00
>       0.00            0.06
> Stack                        0.03            0.00            0.00
>       0.00            0.03
> Private                 307200.75            0.95            0.00
>       0.00       307201.70
> ----------------  --------------- --------------- ---------------
> --------------- ---------------
> Total                   307200.84            0.95            0.00
>       0.00       307201.79
> [root@localhost ~]# migratepages 10764 0 2
>
>
> |---------------------------------------||-------------------------------=
--------|
> |--            System DRAM Read Throughput(MB/s):        844.34
>         --|
> |--           System DRAM Write Throughput(MB/s):        840.21
>         --|
> |--             System PMM Read Throughput(MB/s):        783.93
>         --|
> |--            System PMM Write Throughput(MB/s):        801.99
>         --|
> |--                 System Read Throughput(MB/s):       1628.27
>         --|
> |--                System Write Throughput(MB/s):       1642.20
>         --|
> |--               System Memory Throughput(MB/s):       3270.47
>         --|
> |---------------------------------------||-------------------------------=
--------|
>
>     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ CO=
MMAND
>   11275 root      20   0    2644   1764   1644 R  99.5   0.0   1:46.90
> migratepages
>   11355 root      20   0   10916   6200   3896 R   0.3   0.0   0:00.03 to=
p
>       1 root      20   0   26012  15728  10484 S   0.0   0.0   0:02.57 sy=
stemd
>       2 root      20   0       0      0      0 S   0.0   0.0   0:00.13 kt=
hreadd
>       3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
> pool_workqueue_release
>       4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-rcu_gp
>       5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-sync_wq
>       6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-kvfree_rcu_reclaim
>       7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-slub_flushwq
>       8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-netns
>      10 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/0:0H-events_highpri
>
> Samples: 125K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 54514328868 lost: 0/0 drop: 0/0
> Overhead  Shared Object                      Symbol
>   45.48%  [kernel]                           [k] migrate_folio_unmap
>   18.24%  [kernel]                           [k] clear_highpages_kasan_ta=
gged
>   15.00%  [kernel]                           [k] copy_mc_fragile
>    1.83%  [kernel]                           [k] smp_call_function_many_c=
ond
>    1.18%  [kernel]                           [k] page_vma_mapped_walk
>    1.07%  [kernel]                           [k] try_to_migrate_one
>    0.99%  [kernel]                           [k] folio_migrate_flags
>    0.76%  [kernel]                           [k] rmqueue_bulk
>    0.72%  [kernel]                           [k] remove_migration_pte
>    0.53%  [kernel]                           [k] __mod_memcg_lruvec_state
>    0.53%  [kernel]                           [k] migrate_folio_move
>    0.51%  [kernel]                           [k] __free_one_page
>    0.50%  [kernel]                           [k] lru_gen_add_folio
>    0.49%  [kernel]                           [k] rmap_walk_anon
>    0.49%  [kernel]                           [k] folio_batch_move_lru
>    0.46%  [kernel]                           [k]
> __list_del_entry_valid_or_report
>    0.46%  [kernel]                           [k] migrate_pages_batch
>    0.45%  [kernel]                           [k] folio_add_anon_rmap_ptes
>    0.32%  [kernel]                           [k] mod_node_page_state
>    0.32%  [kernel]                           [k] up_read
>    0.31%  [kernel]                           [k] lru_add
>    0.30%  [kernel]                           [k] __rcu_read_unlock
>
> Samples: 175K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 66480019193
> migrate_folio_unmap  /proc/kcore [Percent: local period]
>    0.01 =E2=94=82       movq   %rdi,%rax
>         =E2=94=82       movq   %rcx,%rdi
>         =E2=94=82       movq   %rbx,0x8(%rsp)
>         =E2=94=82       movq   %rcx,%rbx
>    0.01 =E2=94=82       movq   %r12,0x18(%rsp)
>         =E2=94=82       movq   %rsi,%r12
>         =E2=94=82       movq   %rdx,%rsi
>         =E2=94=82       movq   %r13,0x20(%rsp)
>    0.01 =E2=94=82       movq   %rdx,%r13
>         =E2=94=82       movq   %r14,0x28(%rsp)
>         =E2=94=82       movl   %r9d,%r14d
>         =E2=94=82       movq   %r15,0x30(%rsp)
>    0.01 =E2=94=82       movq   %r8,%r15
>         =E2=94=82     =E2=86=92 callq  *%rax
>    0.21 =E2=94=82       testq  %rax,%rax
>         =E2=94=82     =E2=86=93 je     2e3
>    0.01 =E2=94=82       movq   %rbp,0x10(%rsp)
>    0.01 =E2=94=82       movq   %rax,%rbp
>    0.07 =E2=94=82       movq   %rax,(%r15)
>    0.00 =E2=94=82       movq   $0x0,0x28(%rax)
>   99.10 =E2=94=82       lock
>         =E2=94=82       btsq   $0x0,(%rbx)
>    0.02 =E2=94=82     =E2=86=93 jb     26b
>    0.16 =E2=94=82 67:   movq   (%rbx),%rdx
>    0.01 =E2=94=82       testq  $0x2,(%rbx)
>    0.01 =E2=94=82     =E2=86=93 je     e2
>         =E2=94=82       cmpl   $0x2,%r14d
>         =E2=94=82     =E2=86=93 je     d2
>         =E2=94=82       movq   0x40(%rsp),%r8
>         =E2=94=82       movq   %rbx,%rdi
>         =E2=94=82       movl   $0x1,%ecx
>         =E2=94=82       xorl   %edx,%edx
>         =E2=94=82       xorl   %esi,%esi
>         =E2=94=82       movl   $0xfffffff0,%ebx
>         =E2=94=82     =E2=86=92 callq  migrate_folio_undo_src
>         =E2=94=82       testq  %r12,%r12
>         =E2=94=82     =E2=86=93 je     1b0
>         =E2=94=82 9d:   movq   %rbp,%rdi
>         =E2=94=82       movq   %r13,%rsi
>         =E2=94=82     =E2=86=92 callq  *%r12
>
>
> [root@localhost ~]# COLUMNS=3D500 numastat -p 10764 | cat
>
> Per-node process memory usage (in MBs) for PID 10764 (stress-ng-vm)
>                            Node 0          Node 1          Node 2
>     Node 3           Total
>                   --------------- --------------- ---------------
> --------------- ---------------
> Huge                         0.00            0.00            0.00
>       0.00            0.00
> Heap                         0.00            0.00            0.06
>       0.00            0.06
> Stack                        0.00            0.00            0.03
>       0.00            0.03
> Private                      0.00            1.02       307200.75
>       0.00       307201.77
> ----------------  --------------- --------------- ---------------
> --------------- ---------------
> Total                        0.00            1.02       307200.84
>       0.00       307201.86
> [root@localhost ~]#
>
> Anton
>
> =D1=81=D0=B1, 3 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 00:34, Pe=
dro Falcato <pfalcato@suse.de>:
> >
> > On Fri, Oct 02, 2026 at 09:55:32PM +0300, Anton Gavriliuk wrote:
> > > > I'm unfamiliar with Valkey, but you may want to ask how contended t=
hose
> > > > pages are if they're actually being used during migration time.
> > >
> > > > Do you get this same behavior when migrating the same amount of mem=
ory
> > > > allocated by a toy program? (i.e. known idle pages)
> > >
> > > I don't think that there is any contention.
> > > There is no processing, etc.
> > > This is a completely idle test server.
> > > I just populated 300GB memory by key-value data store.
> > >
> > > Even if I use simple stress-ng instead of Valkey,
> > >
> > > [root@localhost ~]# numactl --cpunodebind=3D0 --preferred=3D0 stress-=
ng
> > > --vm 1 --vm-bytes 300G --vm-hang 0 &
> > > [1] 4353
> > > [root@localhost ~]# stress-ng: info:  [4353] defaulting to a 1 day ru=
n
> > > per stressor
> > > stress-ng: info:  [4353] dispatching hogs: 1 vm
> > > stress-ng: info:  [4355] vm: using 300GB per stressor instance (total
> > > 300GB of 6.43TB available memory)
> > >
> > >
> > > [root@localhost ~]# COLUMNS=3D500 numastat -p 4356 | cat
> > >
> > > Per-node process memory usage (in MBs) for PID 4356 (stress-ng-vm)
> > >                            Node 0          Node 1          Node 2
> > >     Node 3           Total
> > >                   --------------- --------------- ---------------
> > > --------------- ---------------
> > > Huge                         0.00            0.00            0.00
> > >       0.00            0.00
> > > Heap                         0.06            0.00            0.00
> > >       0.00            0.06
> > > Stack                        0.03            0.00            0.00
> > >       0.00            0.03
> > > Private                 307201.14            0.74            0.00
> > >       0.00       307201.88
> > > ----------------  --------------- --------------- ---------------
> > > --------------- ---------------
> > > Total                   307201.23            0.74            0.00
> > >       0.00       307201.97
> > > [root@localhost ~]# man migratepages
> > > [root@localhost ~]# migratepages 4356 0 2
> > >
> > > I see even slower (System PMM Write) than 1.4 GB/s,
> > >
> > > |---------------------------------------||---------------------------=
------------|
> > > |--            System DRAM Read Throughput(MB/s):        842.67
> > >         --|
> > > |--           System DRAM Write Throughput(MB/s):        851.34
> > >         --|
> > > |--             System PMM Read Throughput(MB/s):        785.27
> > >         --|
> > > |--            System PMM Write Throughput(MB/s):        804.57
> > >         --|
> > > |--                 System Read Throughput(MB/s):       1627.94
> > >         --|
> > > |--                System Write Throughput(MB/s):       1655.91
> > >         --|
> > > |--               System Memory Throughput(MB/s):       3283.85
> > >         --|
> > > |---------------------------------------||---------------------------=
------------|
> > >
> > >
> > > top - 21:49:22 up  4:53,  3 users,  load average: 0.97, 0.78, 0.61
> > > Tasks: 774 total, 2 running, 772 sleep, 0 d-sleep, 0 stopped, 0 zombi=
e
> > > %Cpu(s):  0.0 us,  1.8 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.0 s=
i,  0.0 st
> > > MiB Mem : 6839822.+total, 6432377.+free, 422358.2 used,    790.2 buff=
/cache
> > > MiB Swap:   8192.0 total,   8192.0 free,      0.0 used. 6417463.+avai=
l Mem
> > >
> > >     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME=
+ COMMAND
> > >    4507 root      20   0    2644   1764   1644 R  99.8   0.0   2:20.6=
3
> > > migratepages
> > >    1592 root      20   0   82184   5056   3932 S   0.3   0.0   0:07.2=
6
> > > irqbalance
> > >    4993 root      20   0       0      0      0 I   0.3   0.0   0:00.0=
2
> > > kworker/50:0-events
> > >    4999 root      20   0   10916   6080   3772 R   0.3   0.0   0:00.0=
3 top
> > >       1 root      20   0   25528  15488  10484 S   0.0   0.0   0:02.3=
5 systemd
> > >       2 root      20   0       0      0      0 S   0.0   0.0   0:00.0=
6 kthreadd
> > >       3 root      20   0       0      0      0 S   0.0   0.0   0:00.0=
0
> > > pool_workqueue_release
> > >       4 root       0 -20       0      0      0 I   0.0   0.0   0:00.0=
0
> > > kworker/R-rcu_gp
> > >       5 root       0 -20       0      0      0 I   0.0   0.0   0:00.0=
0
> > > kworker/R-sync_wq
> > >
> > > Samples: 26K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> > > 21652648047 lost: 0/0 drop: 0/0
> > > Overhead  Shared Object                      Symbol
> > >   21.77%  [kernel]                           [k] copy_mc_fragile
> > >   18.88%  [kernel]                           [k] clear_highpages_kasa=
n_tagged
> > >   17.81%  [kernel]                           [k] migrate_folio_unmap
> > >    2.67%  [kernel]                           [k] __folio_alloc_noprof
> > >    2.09%  [kernel]                           [k] smp_call_function_ma=
ny_cond
> > >    1.89%  [kernel]                           [k] try_to_migrate_one
> > >    1.74%  [kernel]                           [k] folio_migrate_flags
> > >    1.69%  [kernel]                           [k] page_vma_mapped_walk
> > >    1.14%  [kernel]                           [k] remove_migration_pte
> > >    1.01%  [kernel]                           [k] rmqueue_bulk
> > >    0.88%  [kernel]                           [k] migrate_folio_move
> > >    0.87%  [kernel]                           [k] __mod_memcg_lruvec_s=
tate
> > >
> > > Samples: 111K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.)=
:
> > > 56222244297
> > > copy_mc_fragile  /proc/kcore [Percent: local period]
> > >    0.00 =E2=94=82      cmpl  $0x8,%edx
> > >         =E2=94=82    =E2=86=93 jb    43
> > >         =E2=94=82      testl $0x7,%esi
> > >    0.03 =E2=94=82    =E2=86=93 je    27
> > >         =E2=94=82      movl  %esi,%ecx
> > >         =E2=94=82      andl  $0x7,%ecx
> > >         =E2=94=82      subl  $0x8,%ecx
> > >         =E2=94=82      negl  %ecx
> > >         =E2=94=82      subl  %ecx,%edx
> > >         =E2=94=8219:   movb  (%rsi),%al
> > >         =E2=94=82      movb  %al,(%rdi)
> > >         =E2=94=82      incq  %rsi
> > >         =E2=94=82      incq  %rdi
> > >         =E2=94=82      decl  %ecx
> > >         =E2=94=82    =E2=86=91 jne   19
> > >         =E2=94=8227:   movl  %edx,%ecx
> > >         =E2=94=82      andl  $0x7,%edx
> > >         =E2=94=82      shrl  $0x3, %ecx
> > >    0.02 =E2=94=82    =E2=86=93 je    43
> > >   58.57 =E2=94=8231:   movq  (%rsi),%r8
> > >   12.21 =E2=94=82      movq  %r8,(%rdi)
> > >    4.22 =E2=94=82      addq  $0x8,%rsi
> > >    8.25 =E2=94=82      addq  $0x8,%rdi
> > >    0.53 =E2=94=82      decl  %ecx
> > >   16.06 =E2=94=82    =E2=86=91 jne   31
> > >         =E2=94=8243:   andl  %edx,%edx
> > >    0.02 =E2=94=82    =E2=86=93 je    57
> > >         =E2=94=82      movl  %edx,%ecx
> > >         =E2=94=8249:   movb  (%rsi),%al
> > >         =E2=94=82      movb  %al,(%rdi)
> > >         =E2=94=82      incq  %rsi
> > >         =E2=94=82      incq  %rdi
> > >         =E2=94=82      decl  %ecx
> > >         =E2=94=82    =E2=86=91 jne   49
> > >    0.02 =E2=94=8257:   xorl  %eax,%eax
> > >    0.06 =E2=94=82    =E2=86=90 retq
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >
> > > Samples: 187K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.)=
:
> > > 84234492777
> > > clear_highpages_kasan_tagged  /proc/kcore [Percent: local period]
> > > Percent =E2=94=82      nop
> > >    0.03 =E2=94=82      subq 0x1a5067c(%rip),%rdi
> > >    0.01 =E2=94=82      movl %esi,%ecx
> > >         =E2=94=82      xorl %eax,%eax
> > >    0.03 =E2=94=82      sarq $0x6, %rdi
> > >         =E2=94=82      shlq $0xc, %rcx
> > >    0.03 =E2=94=82      shlq $0xc, %rdi
> > >    0.03 =E2=94=82      addq 0x1a50675(%rip),%rdi
> > >   99.72 =E2=94=82      rep  stosb   %al, %es:(%rdi)
> > >    0.09 =E2=94=82      nop
> > >    0.06 =E2=94=82    =E2=86=90 retq
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >         =E2=94=82      int3
> > >         =E2=94=82      nop
> > >
> > > Samples: 223K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.)=
:
> > > 88021056491
> > > migrate_folio_unmap  /proc/kcore [Percent: local period]
> > >    0.04 =E2=94=82       movq   %rdi,%rax
> > >         =E2=94=82       movq   %rcx,%rdi
> > >         =E2=94=82       movq   %rbx,0x8(%rsp)
> > >         =E2=94=82       movq   %rcx,%rbx
> > >    0.04 =E2=94=82       movq   %r12,0x18(%rsp)
> > >         =E2=94=82       movq   %rsi,%r12
> > >         =E2=94=82       movq   %rdx,%rsi
> > >         =E2=94=82       movq   %r13,0x20(%rsp)
> > >    0.06 =E2=94=82       movq   %rdx,%r13
> > >         =E2=94=82       movq   %r14,0x28(%rsp)
> > >         =E2=94=82       movl   %r9d,%r14d
> > >         =E2=94=82       movq   %r15,0x30(%rsp)
> > >    0.05 =E2=94=82       movq   %r8,%r15
> > >         =E2=94=82     =E2=86=92 callq  *%rax
> > >    0.05 =E2=94=82       testq  %rax,%rax
> > >         =E2=94=82     =E2=86=93 je     2e3
> > >    0.06 =E2=94=82       movq   %rbp,0x10(%rsp)
> > >    0.04 =E2=94=82       movq   %rax,%rbp
> > >    0.20 =E2=94=82       movq   %rax,(%r15)
> > >    0.07 =E2=94=82       movq   $0x0,0x28(%rax)
> > >   97.01 =E2=94=82       lock
> > >         =E2=94=82       btsq   $0x0,(%rbx)
> >
> > ...are the struct pages on the pmem node itself?
> >
> > --
> > Pedro

