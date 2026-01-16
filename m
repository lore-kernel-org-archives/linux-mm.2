Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4283C982D1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233A66B008C; Fri, 16 Jan 2026 12:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1516B0092; Fri, 16 Jan 2026 12:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099206B0093; Fri, 16 Jan 2026 12:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E98B16B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:30:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 859D289DB4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:30:18 +0000 (UTC)
X-FDA: 84338515716.14.5EC3F39
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6221E14000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:30:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmPVYNsH;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of vannapurve@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768584616; a=rsa-sha256;
	cv=pass;
	b=RaZJhhSdswgSFNJXBCPfZl8VmHZvwOC9NnGlRNmRZcD8+ZqizzUBmsleAToSf+IEnLAbd5
	/0+swUK/2w2DmikUruqt0zz3BOBMWtQcQd4WPEZg5YPy1laDbZ+XT/b+EblwyWmUNIRfLo
	H7SGPx/zwqsxKczEkEpteBQM3NMX8lA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmPVYNsH;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of vannapurve@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=vannapurve@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
	b=kZLD/DvnOwZ/SZIpEZ/ccfOHZo05gqgDqXY7yo/WhvL1/nvoNKXqtYRz3RIMu6IOBaX2wU
	TeE9weAQWQeXDk7QJBtj8pcHY8qFaMpiC6qgORKltzwbBlBDUK01SIjulNBuNpHiuiaTYP
	PE5bNIq/YRIRi83+2mCtytalr9McbL8=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12331482a4dso10012c88.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:30:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768584615; cv=none;
        d=google.com; s=arc-20240605;
        b=Wkw6DxAeGbt2kbLaKo+Z0VOytFtaJJcGbJyztdJE8IFQEJNTutA8HSjppWItPwjtbF
         Ddn9F5ETbgTVwXOtJfPBkPr6/PAWFgu1gc1yyFUKWzLDjXw8jpdrycqB9dX0evgrHQTm
         3n9ecGPCrZVaJLhdaw0NJlzhzWoVrBuypfkE/Suke7l1bN6T8xCyQjijO9V0GQhKAliS
         hBA2hGsTfHnBdlXUnUdeI6L+MCuRPKwuIXzyA79qmP4DpTJqt21S8BnY7bS3B+TLKwTx
         YiR9rFSf4/1uGhaWq76n/tdNM/Zu6Xe/WlF9vwzkycK/e5U3MZZPnz0FDFF00OvaCHX5
         LvAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        fh=2vhJGjsL8Zmx8Dcd0nusgCvemn6/6p9nBhTaFvYG/30=;
        b=iVSlaV7WoFixpY93//PY+6xZVcS8RHApXwxhuc3Zj+Cm7hhOLJ4L92sQeQjvhdN7u0
         RbtdxVckIUv/ZULUhDiWvHiYAZQ5Oj+NFfQ7A1vcfhHf6OnYhOOa0kMmXmGNfog8VckZ
         5BDNLq+NBWeYgjOQBn8LcoCub6CXvQ9tb6uAimimggf3sVGzQkMZZ5d7JSPQuBKkpKp3
         J40X4sRgQBSMtMywyDdZeS6KcQcbqh+B1XNcGyw1TvZezJEsn2gcK74D+kb5YFFcUFbd
         zeCtw7e5hPA5cNGDHz+Xha3tRbcrgk3wVHBt/lb8FssyBEUc1DnGnDKGCrHwmi626nXo
         6ryw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768584615; x=1769189415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        b=hmPVYNsHo5t8PaxucJdlUFS35HNbVCpOtwrMp7eW6Y165TgdKcB+00vrrHkrtff5wi
         jagqAiNOHai4i80AVg5WjRKgI/7wnX4G/+CQ2nxWvCXEox89trhrF8P8OuQincZxbo2J
         fuP910ct694JQCCVu2VzYlEV3Ag+z7ZMjaNgn0QTlLB4Z4LC1K4cOUBeNobhot/SMNDE
         rEJzhUY03awk4prt5qC7jRO8Qz6YXz3EpVZFUXQSJB1H99YDX2Z1SXP9OH+JHztZ2yKy
         S2IgYTNuZ5R4uEOG+k0ok9P7SrKLZxJXKvWUGe5ayFlDyW/TQw/vClI8avjzf7U1gQ+2
         Jnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584615; x=1769189415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        b=MObZSY7WJvahivQ1qMJkNChDjFrJYSVngbK/cX1/jR3hpq+ZQRZm9Oz6Tj3pShB91B
         fYo1wvXKekg9PJlW/bkniGfyaN8nbkvKhzxNFxw4vuwxEX5DcMZ3UgIkCtjH308hq0AJ
         1XUZxrl9VLxKJuw6qwdcxrCttOlKPpSgabZ+J+EaBqczdEOcO1FtMHpTynqJY9nADhTB
         cZTTiKlI3U2LjfX4+aewx58KbeQ6opUihYI5/UiOgR399PDyPtkDpWjq+pPmLqUjGxIN
         yUoprphf7DWbvBoV0MuF19o7mfEvKDxZmOEJvLMO8dWM3aHIoIgA87ZxrhrOuXDu6fLw
         kmaA==
X-Forwarded-Encrypted: i=1; AJvYcCUd9xCWqCef7jx4pPstHNu7JOsOK7kLh46umngZOAUGJ9QA9PSo25aZZduh+fT6D3VWv7x9GRrYtw==@kvack.org
X-Gm-Message-State: AOJu0YyOrkZt376j2B0n92T6CTsXrZkEfisiNe5LObLnoG5wDzx/jy9S
	DQFaS/p8ktMW6CEPb9kzcx4a2vgvNHIRu8b3vu7AsiwSUgns+5ClmsxHQhXZ9Tk1cqyaa/uoyy2
	MPor1Ff3s4dVahkVrukBMiQLd7jIIrg+iS2NzEvGc
X-Gm-Gg: AY/fxX5LPDR064DDrGQq5lygND6yOPd8336TpiZDgewYrDD+DH62qHyTPOM1NUvDppO
	buK8AVPRvc3Gk6VH5zuS8tl2tF/de4EHn+8lfZ3fkVfQV4JUMHjNRLvC1+z4O1qKqbHJSdMK1u8
	I+QAlxabMZ1OYLWVAxq3Ew/5np8o3MlyLWVjfHS1VC3P23LNvru0nrqFhXNTU0i0cQ3aMPDO7XB
	GIKvFefWQ1YYW4EheShcdu6FgOwoYUm3JLqWINDO8nekbuBKDn34h7eAv6ohJAd2fOnjZoMFuME
	rWQ1ZJp+GlwK5Ft5mnxhKSWNTTYgCFC8FD8yASI=
X-Received: by 2002:a05:701b:2212:b0:120:5719:1852 with SMTP id
 a92af1059eb24-1244b44d299mr107912c88.16.1768584614413; Fri, 16 Jan 2026
 09:30:14 -0800 (PST)
MIME-Version: 1.0
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
In-Reply-To: <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 16 Jan 2026 09:30:02 -0800
X-Gm-Features: AZwV_Qg33M1rO31dgikgfsTaot12EQbVpaEnX3TxsJMPXzhkvu_Y-NHzJrI17yU
Message-ID: <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "david@kernel.org" <david@kernel.org>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"surenb@google.com" <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "pjw@kernel.org" <pjw@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "willy@infradead.org" <willy@infradead.org>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "wyihan@google.com" <wyihan@google.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"jannh@google.com" <jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, 
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6221E14000F
X-Rspamd-Server: rspam06
X-Stat-Signature: otzuhti83unbfyefhfyzo5iu9kfupy4z
X-Rspam-User: 
X-HE-Tag: 1768584616-317748
X-HE-Meta: U2FsdGVkX18ecb1qa/RnxgovzqL4vGVotmHbl7HXTWetK0Hl7wqwuhVjqnpEaxEyD0sJdr5yN7U/OQbWUlPlV8vcVD9l2z6if5e1yLmipj/C4UIUOcfdQvcHwDqCbRKJGhFFqDMDmLYNgzvh9CEqbyjR9CtRVWTpO3eWIs/ndQnYhVJXJ+NPUAj0e9aDuTos+s9E/EAvceW21jH09nfwh6ZiE7hq8id26njccBMDNpGHBtpb662wS1bAY4cO9mxzUcVV6bArMtkmHRYi80sRZl1/rWY7KPr8VQGKIObiqnE287bFPcXA3wmHswJE99POIjHajAcsJ6FjVSgFqAZFgGZKr/QRpNwuhE/01o49VWnkG1jx3g12l8QIUDiN0sRkGit47Vu6RVHbCahyd0dowSbq1AMSCuUfHPkyBZo9f+cgvFmlYR9P2JvuyECcXBG42GM+ECo76q+uIUTctupP54pnkxSCqA7j2n6DXOsy2SDmzSIWsg4Ravu2hoSdJ01IiEFh8sUSXnpYbA38XQpEO2MjuZp64p8duPFVHOIemhWZVNlgLRR/pcQUv6ktmew+o9yXnzKgQmwIN+oSRFuiLOe8ByN469eYaDgHtPQrAiAyTwrVHcjBTHmf934M0sFxfwFKko/H3HBFuS5Y6gDDy0wrY6nEWwkbJ6Ih325dcjczO4A5b5hUqXTeZ0lnwnq2QckyBGx7oZB74NO6LGH0Yznb18oAUIPygwb4mhdCPeE9qVSIl2rVrDNNDRmX53azPaJpGqEp7tCW2XdkQXUqpXX2NyaaVb7niKDNd/q2KMkOlIdqclxiPBTjZ/p2HMw9CKNObfIfks6H6BF67+P5I83yjUWUFAFxpvbMEqnIlN1kLG62m8jbxpKEMra4GndSB+G7W8g31ApxllnSKlMPAnKPyFT8Jeb6hJEJxckMuE4ULklhJj+2n872Ms9oOmRDPCo+w5volmnCyF5Rncf
 37U/9xme
 PQrXd945imXNJAJ5FwQtXrI1XOGJy8iDrvi0UaQ4i01nT0hafpD4Xc5lKgMnMZoc7bi4eoaSx8EuLE6YyvL08ieh5Ma5nWbL/VgmxVqxmm4AUfuRF5bjuq8QYWxfnBp10oRZqvw5DP+i+vk7i51dua3WuY8JV1gcF3jmXTHTQMVONZe5OmK1CbF6LpnDoenByN7xOX84Ef8Ni98OR8MGh741gkPZnvnRXT8iD3blm1efPL6oWXdPISsqY+NdbQfH7OOaQ3fiytPulQRP9jv6bPlYB8ylR779ZsM180QRLAELcLAWLWGbc4l+rKyEugb7JPaf1K+g0+PxvehQ0aF1TB/jX5kNQ4JtGqv2V/iqv/ISZRRBO4whqstxHMrnFk8TTbGII3+RjzwsPD8hgB0PElHH/IefBtlefq44K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 3:04=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
> > Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> > ioctl. When set, guest_memfd folios will be removed from the direct map
> > after preparation, with direct map entries only restored when the folio=
s
> > are freed.
> >
> > To ensure these folios do not end up in places where the kernel cannot
> > deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> > address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> >
> > Note that this flag causes removal of direct map entries for all
> > guest_memfd folios independent of whether they are "shared" or "private=
"
> > (although current guest_memfd only supports either all folios in the
> > "shared" state, or all folios in the "private" state if
> > GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> > entries of also the shared parts of guest_memfd are a special type of
> > non-CoCo VM where, host userspace is trusted to have access to all of
> > guest memory, but where Spectre-style transient execution attacks
> > through the host kernel's direct map should still be mitigated.  In thi=
s
> > setup, KVM retains access to guest memory via userspace mappings of
> > guest_memfd, which are reflected back into KVM's memslots via
> > userspace_addr. This is needed for things like MMIO emulation on x86_64
> > to work.
>
> TDX does some clearing at the direct map mapping for pages that comes fro=
m gmem,
> using a special instruction. It also does some clflushing at the direct m=
ap
> address for these pages. So I think we need to make sure TDs don't pull f=
rom
> gmem fds with this flag.

Disabling this feature for TDX VMs for now seems ok. I assume TDX code
can establish temporary mappings to the physical memory and therefore
doesn't necessarily have to rely on direct map.

Is it safe to say that we can remove direct map for guest memory for
TDX VMs (and ideally other CC VMs as well) in future as needed?

>
> Not that there would be any expected use of the flag for TDs, but it coul=
d cause
> a crash.

