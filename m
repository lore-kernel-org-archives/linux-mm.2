Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3062AD2D0FD
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54EB76B0089; Tue, 13 Jan 2026 09:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530116B008A; Tue, 13 Jan 2026 09:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459216B008C; Tue, 13 Jan 2026 09:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30DB76B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:03:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F58E1386F8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:03:13 +0000 (UTC)
X-FDA: 84327107466.22.06D4F4E
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D30B100042
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:03:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=I0duCVe7;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768312991; a=rsa-sha256;
	cv=none;
	b=nQ1y8bkUWXkQUCGoMaptSZmmzdn8iYKIUAM2T4UVLvlZeE9IZtp5050d0C2p5Z1j03H1w3
	oGlFPdXiaPhEBhIFslxw16gAmkVECvIIVKLzSuTJwWf/QodFf3/8UrzjxEvC4FW1RvKCNX
	yoda1ddxBL5rnPhFA9Y3RtNPFvdxCmM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=I0duCVe7;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=9473463a0e=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=9473463a0e=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768312991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQ7j1PpGTasQAblfO8V1KwLqMUsTQm5W+M3/6xbpbQs=;
	b=GAbmZHuChjjL06pPXt/gTqnsIEXwNhAd5I5b1eP4n3UKXaPqy82JHiWreHOVr4yjPL5vgi
	B4CnsM4U7lDDWK7Ld+82MTlmZ9mPOeP2ELvV2pmYw1G9ptVV9Gkbft1P7VWnYhcAD1q8Nt
	0iZqpPDpHODhuin/xuaV6rnddsvpspY=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 60DC4dtS1330592;
	Tue, 13 Jan 2026 06:02:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=fQ7j1PpGTasQAblfO8V1KwLqMUsTQm5W+M3/6xbpbQs=; b=I0duCVe7seY9
	Edk/KTttYI7pSWoYZeM0jlkHIh1rNXqTqRlrmWA5DDtmw+cyr+js5kd+YW+lAEi+
	wyWRsOgyVP7cZXyJ521koGYuvcfbOlqxcIKZ/mtPc1La+qU1EzA1tQDAqWqzY1fy
	WXCVvVWbyhyD6yC5Onr8rK50uhcSnEM3U83BWw94xMqoHGUVKqZkDa2Ls/4vxdnQ
	EcO3t9e3x/msw1qWNheVYhMSk2QU6IHI+SwzmJuYGC6UgBOudhskL9S7uolAqZ5u
	S/3xQ5eaAE1alCHjyZaDTLYG9Kpa+I+venuH2H0GgLg27XuEwq24P8K5o9mZhEwO
	pn4EceYpjw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4bnnr4rsm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 13 Jan 2026 06:02:54 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Tue, 13 Jan 2026 14:02:51 +0000
From: Chris Mason <clm@meta.com>
To: Breno Leitao <leitao@debian.org>
CC: Chris Mason <clm@meta.com>, Alexander Potapenko <glider@google.com>,
        "Marco Elver" <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/kfence: add reboot notifier to disable KFENCE on shutdown
Date: Tue, 13 Jan 2026 06:02:27 -0800
Message-ID: <20260113140234.677117-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251127-kfence-v2-1-daeccb5ef9aa@debian.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::150d]
X-Proofpoint-GUID: -zdoFufYx-ri54AmF2W0YNzuIqDQSvvM
X-Authority-Analysis: v=2.4 cv=Zs/g6t7G c=1 sm=1 tr=0 ts=6966508e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=xNf9USuDAAAA:8
 a=7sR78lRsTtdWeVkM5_EA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDExNyBTYWx0ZWRfX/SH2AzbaA7MB
 fQ7SM27TcoFfggUzHtqIj9YhlO1KEvX/6zhNr8J15aiISa2bEPfqhMxaGMCXMRk7HSSy2FeKxgG
 ibIbIpNHOjRb942E+A/vtvrrW00uQh/2JJikK5QORViYber7Xv8570VWucIgV+Md40nWkQ69a/h
 ceE9JyquvWsfNEG0ymemR3nJfJdFJBhdrqkXF+G4N4dEF3wCYQe9ChjlA5DEOg/VBgeqsjnHq9+
 fDMjeZ5zQVSoy9peZ/++qafLhPPJoHlPHTq/hJ0FOwRdkNTQolGhAI5ikEhdq/6EtAbq6PscK5v
 U8+EjxbMMiTCIYMGLNF4UFv19e8DLo/fL3Mi2lZ+aEcSiIj70a/thIH9S26H8vTe2EGUs5jZ5uX
 tgvHiHwvc/8cojlBjhfmCefn7NaWbU4n/GkF4BpbvDEnVF+bsNROvOPUAnaRQjlW+R9I+QaCBm/
 M6FkDwYwMQY3kxIZ3GA==
X-Proofpoint-ORIG-GUID: -zdoFufYx-ri54AmF2W0YNzuIqDQSvvM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_03,2026-01-09_02,2025-10-01_01
X-Rspamd-Queue-Id: 0D30B100042
X-Rspamd-Server: rspam06
X-Stat-Signature: 3xsoygzq888iyjyd6moajh3qczae13cw
X-Rspam-User: 
X-HE-Tag: 1768312990-530089
X-HE-Meta: U2FsdGVkX19+WlqqX93G2ki0LzwIkxzpFDTGk8fcQ8FFjJfGd6YB8OdpVn8l90pTZ//xA0AgpcPPmrFD8xCb4qE8LTWpB47GokgjDBOcuG3fdm6bFoAHxmLl9VpM1v0MXgNz7r4IGIK3eJ0U6nEuCX+nJ8CRCGN7kNlY1nDx5IFgvDHT+f3hdrxthfeSrgMQONxdJlI//xVwVrT51FPm+FBGFKDOohEjukVGnGRNqjiNy6HLEALYZTn/rhHvbD6jgzAiVslqaZRplSR9AEc0BABnhsUiZ5MtafkFTjh8f9bcokrpNTipdDakBdtuFXFAtVAMIgIeyYyz8rkIj3y5qKIBpN0xJePeWEAlFXzNvqd4YcEpkXv+VZZYH2xXYGb0UAW94UbKNMHDvAUwRAWG3MHKtYj+LgrhCJj07uumq0ouRarqH4OBJImd+i/PPZhX4VR4PLIOPz4opOMac18ZgHe8f/q9gjeh34hqy846Kjg39xkpSEEtlVyeDpW3c6wYsVEYIZwayyr/YticTzO+s710p3PJsfhX/2HubhQb/MU2gi9Nqn4l684K1zVM/ew3fpE0q+BwBIpd6+HmCDv70WeBdE5NsjT1GeGs+Q8oh7NKqif/Szhe1lOzaXG1UooKIfVGQtctLTh/0mZpibqhlVD/i19V9q4u5uJFBINtx5hwEln3sNVBdLtPUu83P6NpqfNYj4Z7ZGMMLBDVToj9XU8Byif+7PRO6N/8UwSSn6rwMsABuTZIUAqw0JhrlRbWVfb+K5uX03nxTOrm2pN5EvCBOyBpUvstFUJ35UKLudJsi0qqJSwbS/d9qsX0j2DJB2wKghFS2mBn0ArTrolWKKXBarszxyfvZoOW4NrjJvlb5jAOf3svAqyxRV00DfY1m7+lXRrjDi2aE4dVHfTriYTYDLuGNsRee3UDdidqCtuzTBkaWAfoR4JV2wsGnikSzn1qC5pLem9b/uA+/bB
 eF9IZtif
 BiNU2DAS6K1lSkgBijmc0zGMXUiejpwoqOrCT2PDiJp5mvMxkk5xVHLnicZmyygE/1E/qMX87UEA+ks8Uxmcd6E814+GJq95o8y8GYjSdNt8Glkg70HhLJeAObVsGbU181xFcZvdSLvuxyMA13k6/hBbmfm/eEBWx3BZ5tY+32T7oS9Hxo/VYoiEuFYI+apNOUAuZ/F9mVRwMbrR9QbzSpwOlhIgK3teHe2yVCqm0a8CcJpCllxnZ4iRikNn6t5Qq5iuphf8M6vE0/iFYHBmAInf053ZjuU7CPoAToyplJ/qo3RIdpXepZF3SDGK4EG0Im+NTRpdLOM4WSrsyC5IVjIfW28jDLhrj6itaGb5X4kaoX84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 06:51:54 -0800 Breno Leitao <leitao@debian.org> wrote:

> During system shutdown, KFENCE can cause IPI synchronization issues if
> it remains active through the reboot process. To prevent this, register
> a reboot notifier that disables KFENCE and cancels any pending timer
> work early in the shutdown sequence.
>

Hi Breno,

I'm running v6.19 MM commits through the patch review automation and this
one was flagged.  Is this deadlock possible?

Automated review output:

> @@ -820,6 +821,25 @@ static struct notifier_block kfence_check_canary_notifier = {
>  static struct delayed_work kfence_timer;
>
>  #ifdef CONFIG_KFENCE_STATIC_KEYS
> +static int kfence_reboot_callback(struct notifier_block *nb,
> +				  unsigned long action, void *data)
> +{
> +	/*
> +	 * Disable kfence to avoid static keys IPI synchronization during
> +	 * late shutdown/kexec
> +	 */
> +	WRITE_ONCE(kfence_enabled, false);
> +	/* Cancel any pending timer work */
> +	cancel_delayed_work_sync(&kfence_timer);
                   ^^^^^^^^^^^^^^^

Can cancel_delayed_work_sync() deadlock here?

If toggle_allocation_gate() is currently executing and blocked inside
wait_event_idle() (waiting for kfence_allocation_gate > 0), then
cancel_delayed_work_sync() will block forever waiting for the work to
complete.

The wait_event_idle() condition depends only on allocations occurring
to increment kfence_allocation_gate - setting kfence_enabled to false
does not wake up this wait. During shutdown when allocations may have
stopped, the work item could remain blocked indefinitely, causing the
reboot notifier to hang.

The call chain is:
  kfence_reboot_callback()
    -> cancel_delayed_work_sync(&kfence_timer)
       -> __flush_work()
          -> wait_for_completion(&barr.done)
             // waits forever because...

  toggle_allocation_gate() [currently running]
    -> wait_event_idle(allocation_wait, kfence_allocation_gate > 0)
       // never wakes up if no allocations happen

Would it be safer to use cancel_delayed_work() (non-sync) here, or add
a mechanism to wake up the wait_event_idle() when kfence_enabled becomes
false?



