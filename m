Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD83C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABA96B009D; Mon,  6 Jul 2026 05:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84166B00A4; Mon,  6 Jul 2026 05:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0D16B00A5; Mon,  6 Jul 2026 05:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 937906B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:27:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B3861C2DA7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:27:52 +0000 (UTC)
X-FDA: 84957824784.27.2784522
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D8084000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:27:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADhw3IVv;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783330070;
	b=uXYJH5BN/hAaIXnZwTpXpQDp+3lxi8Soyzrytt+5XRwqDkzgX/+wYriuqXdLzICezx0PcE
	0hToTsp74eTanUdMGSF7BAzKqhBFR+3hAqW/wG0n4w08dfFKYVr67CpEYrYdZ2NPjTxErP
	XAT7TEKsf+EYjn9RjUQm+cSEBtQPPok=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADhw3IVv;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wy27XylQTJtJ3Y2kpD07918dwUDlxLsdszQfEU+FnpI=;
	b=CXytOIYrNsWtDt1ZHMWJLWQDGNfNySq6LLHSbldejD2C8i3ySkgstrZxIrQIpQqy7otyfX
	EOdjvoF4Aa63AiHD9SKVpYUi8cBGs9FykHi1oUuILaiEnHRfHlZBKrMSxF7ErMZ2EZJ/t1
	BSM53yerIcnpmy8IWKpSX+FXA81THHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B77CD6138B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308F81F01559
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783330069;
	bh=wy27XylQTJtJ3Y2kpD07918dwUDlxLsdszQfEU+FnpI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ADhw3IVvIBJqwuZaCa9VifOmk4K0PmBXgNAAdXRtR3o1lRi9Qd8v+WEb6LQScrw87
	 4U3Xgw+5gvSY+5+PlHxtJ/gK6wpFsYFCpWniDa3uVgB4XNXbZCDCSZV8fdwhXK2jJH
	 DPlCkUoEY4fct+hRQa1WOm7C5g4Cr1C5ETvy3Iar79747XpVGrGv3B5vVb3wgmCds1
	 Oa5b4YeWIRQsD86cFrayRkKXlhx6hFgnH2u187qWs8QnHtafBUmAyoy94WIyCdZHU5
	 v0NLm9/5UdgjHJ9SbIVK1tVlWLdLbxr+vyX3j1uAhJlD3Fi7OUw5pk6y9fBhGEyUC0
	 AyopSRtUNKQRQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e7632b193so163701285a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 02:27:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpSnmOU2LnK29mheNw1+qgqXgwbjom4yuBWJNXvlu2M5Y5EBL2XAg1WwWTmUDG5dmlx9DlaZZKvHQ==@kvack.org
X-Gm-Message-State: AOJu0YwDp+vwJkFc6bV79h4zxP7b9rLDj/oY81fEPyuLH3cQzD8Ft9Yd
	/TNvvmnFaMQUGCYXu2xzh1YPlv9Q0fFD+jQjYwEP+xQ8j4/igGyk5O6LLa5fYGhskohtSNoJLZ5
	6i6F5kLiE/SDIQEK6gD1ingg48el7Nts=
X-Received: by 2002:a05:620a:459f:b0:92e:70e9:6865 with SMTP id
 af79cd13be357-92e9a4eb48dmr1255848285a.59.1783330068520; Mon, 06 Jul 2026
 02:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260706084232.177786-1-jiangwen6@xiaomi.com> <20260706084232.177786-7-jiangwen6@xiaomi.com>
In-Reply-To: <20260706084232.177786-7-jiangwen6@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 17:27:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w-vUV=-EQd1fDJ5K71b=a606NPrzEubtdmBGteOmasfQ@mail.gmail.com>
X-Gm-Features: AVVi8CdSZB9L0QzLhUWUjoEAyLiw0cSdtQRCJLhNwBUlc06gVCP3iTKrXFbv1G0
Message-ID: <CAGsJ_4w-vUV=-EQd1fDJ5K71b=a606NPrzEubtdmBGteOmasfQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, 
	shanghaoqiang@xiaomi.com, Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D8084000A
X-Stat-Signature: cxwcs7yjprjrfzf33cpejrobna1aezpq
X-HE-Tag: 1783330070-776088
X-HE-Meta: U2FsdGVkX18FaLHOzL+XZOkZH0YP7WjS10wokEqrnEChMIXBqQdm/Z7Y/YnMeedxssDVuu7zNVqCgkSyd61RRbTUACP3Ncm2MEUkjH2+Fv/8oTyEncxY2jS3k8LDgKH9ZYauXBv6BhUi6OEvpE6lVDzCyV4iSDk0DRGzRsNBjDdEyO0jyq0HiXuZtlsBYm75+VRUIKTvo1tKQ3wqgbYpwISCEHfuWb/8tZaPS643k0yoy/sas8rAx/IMLdM+s/onOb11djZGoGBDjG8pok/Yi4K0kGI49urF9yv+yD7kBjZBE1RgTZosACcmnIocL/As+0dFw/BHOHtFpwwa0TEjMLrvyfQYJBw2piRhrPDN1OzjUjSQrrdBUIzX+MIfKdt/UzbF3vEzJmqCf7wdcM6Pc8Kwjmj/BqaQDgLP/FNnNak9I72bNeHz199KH54Z9qdRJz4mw3GoZ7zb9iDncOqqZkJ5a8dePljFkRSV/6xOzUi/A0wcdd0lKA2WXbzF6xDJJIK7IQLaxmuw11/KhzYEBGarBGjt7dYHrmSE9Ad73UF0W2eiVaCGaYwGz3Q/3Irw5thlnkUwlYlucw4gavd7OTDGxJAqenHDKwUF9W2DoxRxbyojQOnKPo9ZgErRuWby0sfv+RNVj2wyg4Pkb6QPU7BjrLjbQcYZTwj/W/bo6tTQw+zvs9zfD0oHS1ycXmtTrnS/LBZUCPqXMCOftAzTwb1N6gH51fujGVdxJDa1awggv7u699uM1QnSo8j5mCpnAKAMyOYla9VDwspRxpumV2BtNTJi7m6uWUmsX9OViWFNOTFXyysFTjMrZ7bqMweJiNxM4Vfzb/UvG3UOcBr+HqkR9pV+5VUC4CWGGE+F2WfODylJllnarDcmfrVm/zZ4DzcrO2eplUQhkHKZBi0bJDM06bvQ50LTeDdTOikEs6SqpXaigGNj/whKMWWvf7O8vVWDIMa7JmMa8cjQjHN
 F/w0x8Fv
 utwpLg4JlmntQXf/m06h7VrOn8fzbIvc1rF6m/OYa2bujMsFrcU5n9F8gs8nZbbphtsAVlaK3afZD0kP2qRJjCXWfpIndxO01ez2oDQp2GaXxbAAHWlQ5wypfGExM3KAX/x6jUq4SCwKNlg/d4Z2gi4KEvQurrwKgfGz15lPyQ726fZk8991SpY803EYVfgzeaWO+U/yO9/0Bdp4g13PW/oxKp15j9BgNH8tAa9+3Y6u+JOzEaR7hy9ERqzSd7N+jVamtDyz/dv53vwxckcAP+Kx5CGY6p84Mng7SdXnms6FSEgNkXce8j9VE0OMplHorQBPIxTmm5PbIC2ohYVp/1ARGQhL3tiWuWwtzDLylnM+XYmSUuKYnIPAKEVybblhSiP+wYKD/h7K/xLBypWJilXts3kmKcWURU+R831H/MQYDqSORKEzJ6NDOZ7tKP2eEFSl+4Rq+Kqw9EvnAq9rcIgkI6eAuW6KbGRKj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 4:44=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com>=
 wrote:
>
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries. We do not expect any significant overhead for
> this.
>
> Add __get_vm_area_node_aligned_caller() as a wrapper over
> __get_vm_area_node() to simplify repeated calls with fixed
> arguments.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>\

please collect Uladzislau's reviewed-by tags [1].
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
also to other patches with tags gotten in v4.

You can use b4 which will help collect tags automatically.

[1] https://lore.kernel.org/linux-mm/aj6m1cFUTlr_DCdj@milan/

> ---
>  mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)

