Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A07CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89813900261; Sat, 16 Aug 2025 02:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F6A8E000B; Sat, 16 Aug 2025 02:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E9D900261; Sat, 16 Aug 2025 02:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628E88E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:57:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA2CB1403B0
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:57:56 +0000 (UTC)
X-FDA: 83781715752.15.CA4CB95
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8FB85A0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:57:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QyS5GcZ+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755327474; a=rsa-sha256;
	cv=none;
	b=a86bm3HHuLwcVnhn/qYJ6iWM+0RZo78YI/SXIBQ6Vj49C63cDrrCMZ4pxOL/UxtmOwi2HI
	/eCjcJjm77H1TlPDI8bVcG71+6XLwvLVrdQJpTPez8dHxLaIgrg+KzGM5yexAQKY35r09u
	V2rMHd/tDEoXBSlUIcKV+gZKorTkGHk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QyS5GcZ+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755327474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg8wKLsgD4C0qASoGGdbCBpxEg9XbKTfPdSgvDSrnxY=;
	b=yEM83fzZ9img08+vGUVMD69MHozvew0sITjykiuboBnSAu2R8gkXUxrJg+7P/TZs0yZr+k
	DomWsCd9DrLD+PZg54nG15wBOZWEY5VoADkae0ZyeoB7k4GbQbxfknuqwO9p8jeYgxAysz
	AjVtSs7UgJkzUvxtGYwhwljn65bGDvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755327474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wg8wKLsgD4C0qASoGGdbCBpxEg9XbKTfPdSgvDSrnxY=;
	b=QyS5GcZ+Yn1CQM/JNbBUnhzNWVvz3ejYb/gle8hAtYEb1lWKY32ly5ib3kKDoZF2Mo+0mi
	uytKh+KuwOkVkY3ryBIZZ48x/xkQ7QeSTCDaB0YxdvJ3u6H+DuOVJV7ZWpFCewpus+dLqO
	xHjHRPIz/Wwa/ZA3JVHnUJVXcfzhSMc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-wJprSbPhMoyo6BQMYARZng-1; Sat, 16 Aug 2025 02:57:52 -0400
X-MC-Unique: wJprSbPhMoyo6BQMYARZng-1
X-Mimecast-MFC-AGG-ID: wJprSbPhMoyo6BQMYARZng_1755327471
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so8217005e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755327471; x=1755932271;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wg8wKLsgD4C0qASoGGdbCBpxEg9XbKTfPdSgvDSrnxY=;
        b=jnInDMWqSK4nBRB6n8AHldXdoUXHZY4K8/zjDHGkKLPYg5CuQUl8tKFntEYyS3EEJt
         F0sa3dfwdAmBp+ZYDxeaMY+VhkALDDH/v69A+OPtrBmwYJBDZTJ8Oe+EKfZ2CQ1imltN
         nOTxjzViKPhwKRg87c9utVfVRbTqkZCWzAF+kHc5WqUH5s8rSn4C+HzKyntPYWBBui97
         HD1YgaktCXMrBnupCWTd83+mHvF3slJKvCyAivQ/OuU9iVr5qQCOq5YsFSHebcpWwpx3
         rPJq3lbT5llKegHVKeObpWm4RXUamwQY4qaq2cMQOMvnh/3L1NvKCAOGYIjJfni3id4h
         VRow==
X-Forwarded-Encrypted: i=1; AJvYcCXXPgMo6HvhkgzLSukCpGQueDx2rGqTMcVU1A7sEL/2UIQQov6PjdgIUlTls5AG4//bqB+vrZMyIQ==@kvack.org
X-Gm-Message-State: AOJu0YyADDVne0dIvlXSbnapCWtUXY2gv8MYkZOJf1UNUp4jo9ddddk/
	Su+8SwC0NUEB6I6tATifjHTY9SjlpfhNBYggK+OjR9fW5kALHrXfpjatBTsxCXNFmFvlCmK84LL
	y7L0rkcyaBpNKcRLfwL0W6cEL0WaV4dvPSNnvg78a/njggjDzHpjz
X-Gm-Gg: ASbGnctttA1jEs26UJczb9yU4jiJE2ZIR2F0sailfKnosGI6aIBCFpUncQi0Ep5JBxz
	GA5NQWPtM93x9s8zzCrV+lt8LMdm9xMAjUviLdR86hQ3ZxrX+tBfMApOmDMTh7kk16F/AEWKBzJ
	DcG37JFblaOR19KBknvqBd/5uteSkjcvfEuVSJ2X8jr7Ovv3WyiF94rqFVhFP1Spd3dHUimMoqv
	9lqphiQMbEr8pNJcy3QIqHPgU2syIKS3esEdVMlF2bl+LO8yoTgK83rSmb1iJi0aSzHjH7/LeIW
	Ln1K2wxPZZ/fecduI9nkypp1JP5PNxmUI+GQAekXO7v7hvve6HBGFySbKzOjL4XtWdBfp/pOevr
	w/MCAKZopcHYIltPVszLDr07yP4gPvTTRVJZTtrMFkskE80elIBdOH8XXy4oaI0nB+0Y=
X-Received: by 2002:a05:600c:c8c:b0:456:fdd:6030 with SMTP id 5b1f17b1804b1-45a21839acemr39164345e9.19.1755327471429;
        Fri, 15 Aug 2025 23:57:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOjp2/h7DEpRetBzYCh95sTuQHMs3qZPndjitRLIlFMSSKwzMEFfJZgCwWmyFWpiYtiA8F9w==
X-Received: by 2002:a05:600c:c8c:b0:456:fdd:6030 with SMTP id 5b1f17b1804b1-45a21839acemr39164235e9.19.1755327471052;
        Fri, 15 Aug 2025 23:57:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b226eecsm53774695e9.1.2025.08.15.23.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:57:50 -0700 (PDT)
Message-ID: <b95b62e2-3e71-4029-9f15-2ce780b1b91d@redhat.com>
Date: Sat, 16 Aug 2025 08:57:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
 Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
 <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
 <9be479a1-ab93-4ec7-b1aa-68acd94f15ea@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9be479a1-ab93-4ec7-b1aa-68acd94f15ea@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6Spmf9C5eGQdK2r_JIrEFGBM85h_cdcZtE3-Q5JZs7g_1755327471
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8FB85A0005
X-Stat-Signature: use56u57d7w9kpnefqm7u6jemcbuws1z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755327474-109679
X-HE-Meta: U2FsdGVkX19odOGgqnP+r1yjZ2CYAE8NtTrHmrMsHsOev5+dLE0pirkkyx1TlNoVxidraTBNsYXRtyJn+t9TbdaacFUasx+b0LOtnckLZwGo4s0Mp0Pd0fz7mnEMC26WRtUI55n/Mbxb6/GMwzy9O3jozC2yndvLwDgA5N9ti0NRlXWOChvRgWSA7RBgVoXoLxP/7IU2u0XHLKt3oKcBg7t3N5aDZ2XAUhLIIr6RwyIHi5Mqaec3iNk1wriiVi1w1VRxQpUbcg9IVH4/wdq8jkkDSSJ0DPWKzb4kYGdV2M5RjnEuerm0VH9FkMBOoJ5Sp6Gj4FX0N2pKmNRp+p3OHr4sVhNU+pxqw+4FTaiuiN7zuxE4K/OvmnE7XJvlW00tOrKMElJkroepVzc/sYHLpUfoLpC8JHjWXw20WEZgaECMjTEZAq6iojY3ASrM2AscIOQFdxc/iTiJoQdU0i6GqPe5RGo7agEkZZeREuIl4oO01V2r7OT+tvzDtEh/eO1VqsQ+MGZFxvZP2qTYvmRa6TnWidyBLr4bc0w3H+v78/mCxqtr83mcn3IISmSGogl1iZy0nCQzpuuLi5dmwiRFZb/iuLNlUKEI8hfenW+z2uWqtbGaXf4a2SXA20V4Ro3yXNCgKsrjAfR+b5kFmCOSXgSyLX0xw7TEHsjNFEqzR5nbVaLlJ2f3Y5VXFYaXTAqUqvDXfAWopLOxJ9Tl5jdrCn31AOO8o1WCLER7ip2UTngWg7N5K3q+c17bdDit31B4zviuej0IqddsimWXS03nLYeQ++9s4T63oVMWR+r5ZQOEH52EvNJGueTy9HJGYtSRv5+YGe+YUOv2EfvT7v/Q3ImlCWAxrqFBQDI92Dy0PChQjPVdPcSv0iHXkLWrCYWq+87XmLuQDyYp8KJEKeQAjoWFJI32J6KHx/O3RSAtTEecKgoZ3187egyY5yjlPcKmez7Z8U4st2PT2hGOJE0
 899ANyZ7
 Mh1OnrjQL4d0bQbIRMu2ymL/ekW4bs5vztN6B/x1Yoj9UKNbEoAETEgUBNATguOBAby3K7ywoRMXy4zpVNbX89RIem7giKk6YR7oyQqcFFTXoYXTG3mxaqTJi/W4psjju63CcKIP+ulU93L2i7dfNHarzO+mg135EezhJh19IYKQypjRnzgq3sYCc2MDBsn+IWCKxk2KLwb5KKDPTigbwmQ57yQKCVQc3qLuHfu15AYSX16IzrIbPjFi8Q3+7IJZn5jfaVQcu/TT0xIuxuMGLgSVwwEWEpbSPN6SizhkuhpLfZg1o7eYD2I7VuhasG9bMznc06SHwI+MNDuqISUxL4qwnfIY0Tpol4Q5sFLqpEqjUkJtvtwdg5vDP3AdZpd/NLDuGrKIo+XiUnpH7PstwKOoCx19SdaAjLZb41pTCXT8Iu7bogvF5UIcz3Lc1IU5CR42ERxoPLl3E9YtqrSa21oTKxzu7jSDrye7a4Kz6gKn2NHNypkumphAsJNE1IXsXVi5uiGOQu9kPiyXNXoK8S2wXpaofNshuEyAHgn2QkpQHtCGCJVsT6Ld3YiCbqq7c5eXxVELP6xGfyPd1h57HTJusRuvhkpqQ+qYH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 08:42, Giorgi Tchankvetadze wrote:
> What about using tracepoints?
> Add a trace_cma_alloc() event that only runs when tracing is enabled. No
> lock unless someone is actively monitoring

Tracing in general sounds like a much better approach here than the two 
pr_debug() in this function.

-- 
Cheers

David / dhildenb


