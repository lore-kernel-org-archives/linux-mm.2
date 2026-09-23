Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAB2C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85346B0092; Wed, 23 Sep 2026 19:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A367C6B0093; Wed, 23 Sep 2026 19:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924EF6B0095; Wed, 23 Sep 2026 19:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D06E6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:28:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA8C61A0115
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:28:11 +0000 (UTC)
X-FDA: 85246617582.29.F479D07
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf04.hostedemail.com (Postfix) with ESMTP id F04A440002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:28:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/tjJQbH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790206089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIrOn8xctsdQQDNeQdRku02Zq+U+2COm+blhhp9fc/s=;
	b=GwA4T2FD6BjLAkwVLIEXDuo8Uw0ycrvOzYnp9kjCUjUZm5gq6Que1ARcA33YWM7SOTg40Z
	9Bxn2gdUXN1mHTlTC4cIvtA0PZjwlNWJ1cuJH873URYosMJ1yvUHWfUXRh85QI66jcxw+C
	g1l9SkZ8Pc0MPZPdL+fp6ADXszxjCvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/tjJQbH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790206089;
	b=2/AuXyIrQqRbAdpNqT7sFJXjom731bcAQUt57XafqC0NPFroQaExUpKzvohImg5zdx0jon
	fC8puJoRqmDd2mz+5JLx4uI3ixFe5IE2F2uMUGE4fdf9okbsJdQFzlgXq21m5IUva5ER5h
	ICG50HF/vpnrYTvaBI3RFLg7z15m7TU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MvumBShhqXhAx5A4XnSnlBOd7T1e+nrArHC0D0D2ILE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790206084; v=1; x=1790810884;
 b=p/tjJQbH1r+Mu4nL+WUVU8yNeG/vzL3ZUqHLb4IqRFIVu4VN5T+AEiNOWvIYKZ0gLmhPefJH
 awaqW6uhHo3Lhy2dHoH8L6XXjQXSXvVhsPlqcvOwc58DeEVCznc3QzGnVpWH9d9scyQL7UYBgSC
 QGSZyVZ30ekzOg1481IxbJ/A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9e4aaf2a06ca83ad;
	Wed, 23 Sep 2026 23:28:04 +0000
X-Mizu-Trace-ID: 9e4aaf2a06ca83ad
X-Migadu-Flow: FLOW_OUT
Content-Type: multipart/alternative;
 boundary="------------w02yeVEA7OyGJFRzsrh3hdEm"
Message-ID: <d4547411-eeae-46c5-a30b-12d8cdde9329@linux.dev>
Date: Wed, 23 Sep 2026 16:27:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260918200640.887030-1-dmatlack@google.com>
 <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
 <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: rmrjymzwqis6h6nsaruhcnazoygwn3yh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F04A440002
X-HE-Tag: 1790206088-372386
X-HE-Meta: U2FsdGVkX19bGgQ1LPQdj+pzX8ZX6b17dtCNhhTcHCMxadVCfsVU/utCkzVkIl0yIuOpksL9MPHkyq7qSmeyU9k1Eg8QRLQ3d12PcoCBDI31ZFY3+6bZgV0Y+r4UOD5VcXhFrrYOwtfUXRRfAJz5KovoPz8YARtcxezvNyBIFfxUfuMZzsEuWkeqhAGZ/eo0s2O08PUD5BeLGFG73d6gDmnuHY2ObnZmkVVCQ+qxrX0xX6fwZAU+lOV4yjI0gM4EzlvMYe9TwuwvTripMib+5WJHNR3grLl3+GdImvX/alIcUIeil5qyaf724JyR6g2TzZsiipUeYZ4lwcOWM/oHsPldVCSGR4nHl6Ynyi0PSOdrygAUUsvYIG5Ci8SVtFkG+P4Rwx0aeEWLz6JEFfVDKgRm3i7Cz/2Yvl8Vi6camPQDgy3EFsVyFloXjmA1N5xyduMGchPrfRDLe5DKPdGy9qaJTY1CLnTfzfc9ZMX4uL8V+nU9rA/TwHaMF/S/vZBy6+7d1OIrEA84GvaznBHJP5jerRipFiaK7xObL9X3lOZWaAtnETig4WNERRqMdNKWKYWnX0LDDxr42M2yDjfm7gXO3kJgs8c3GjP7fCRXskggQEmozfCtor/mUQixtNPnDKPID544tXFakzKZ5X+c4GBQpOjvEmJ3oMQyxkXFJThHa8dFnb59Tmi8vbgOc/0kbZ2InR8y17WbYbqI8y3C4XcUr3OXg+kB0BQ7kc4M/FpSY1dcmGIZCCFIiJpdwl3CuIeYoBOei13U1VzGIKqTe4ZjhU0SHLayLJPCvgjs4/l2mWx0Bvg15mTE9/9HZj827Q2PAvLv21Y9qMRxYgDIfqdhgxjbbdGWTyIrksFMdVBoB7zmLyQUNMUcIJoJz0sfrJjC9pnagA6cgNgF6WCgn5sqnt6a1oX3RMxeEnNSXgcq+SWW9ON3x1Kc3tJJE6Xa+5v4FLvDRr0lSk8k0q/
 BGuDsy4p
 YczDyJjdTH8ZWpAit73FpMM+tq9D3zE594/YkgeXtB31Tv1KUr+aCO+Li86FYuCfF7AvTQdx/34LCTeczZkwn9dC+CZuJMm1bdePZBwzDtvbfz374/W3fWBBLvJF7Q+3oj4o8lVUNVNRiYcKchl8ACdcVWuNf9MVWB2iCLzxtbaK7B7O/DZTLTnylZMc2n6Y1Gfw5jZFPPlNUKbs5hZSi6aiMpFG0oD+tVa8who1vr8EG+un2wsSRq9diFWs93CgVqu2Y69r8sJ+zJAFlFl20Qdkw/DGpjJfQZs8wqp79unurcy0FydyJGQJQjNoyM9TAnJQVG7RRZrMumvjlfV38XOQ/FrMA4apN0oPIU0/bMj1cKOqzV2gKirC6NrIxA5QO4JTdd8iAG25IcJ2iJnOvpRGmea5c0HOAiHc40Inneh/ki4gECUxXW+Dm22AsctD0UJ0GZGlZgkCG6HMK3h3deQ3oFWCCoY/HXzoTgXcOP15MNuxtzn6t+w38Ess4WDESbQ5cyYgL7GWfbTGrvNlwYsPGUQ7ad17sQxRTMUbM3AvIf2tyBIsxKA9E0ihMVB3Qc6Nh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------w02yeVEA7OyGJFRzsrh3hdEm
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/22 11:53, David Matlack 写道:
> On Tue, Sep 22, 2026 at 11:36 AM Zhu Yanjun<yanjun.zhu@linux.dev> wrote:
>> 在 2026/9/18 13:06, David Matlack 写道:
>>> Future Work
>>> -----------
>>>
>>> Following this series, we expect to make further improvements to the PCI
>>> core support for Live Update:
>>>
>>>     - Allow P2P across Live Update by avoiding resizing or moving
>>>       preserved device BARs and preserving all upstream bridge windows.
>>>
>>>     - Support preserving Virtual Functions by preserving SR-IOV
>>>       configuration on PFs and enumerating VFs after Live Update.
>> Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
>> kexec is a foundational step for minimizing downtime.
>>
>> As we look toward complete end-to-end support for DMA preservation
>> across Live Update—especially for VFIO device passthrough and dma-buf
>> sharing scenarios—IOMMU table/domain preservation becomes crucial to
>> prevent IOMMU page faults when devices continue performing DMA during kexec.
>>
>> I would like to ask about the current status and roadmap regarding IOMMU
>> Live Update / KHO (Kexec Handover) support:
>>
>> Is there an ongoing effort or RFC series for IOMMU handover / page-table
>> preservation currently in development or under discussion?
>>
>> How is the coordination between the PCI core Live Update mechanisms and
>> the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
>> restoring domains or handing over root tables)?
>>
>> Any pointers to active discussion threads, RFCs, or future plans
>> regarding IOMMU participation in Live Update would be greatly appreciated.
> The first IOMMU series to support Live update, can be found here:
>
>    https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/

Thanks.

I have a question regarding the restoration sequencing when module 
dependencies are involved during a Live Update reboot.

For the standard hardware/driver stack, the sequence seems to naturally 
follow the kernel's early initcalls and device probing (e.g., IOMMU 
early hardware handover -> PCI bus topology/BME preservation -> IOMMU 
domain attach & DMA ownership claim -> VFIO/iommufd cdev binding).

However, if there is a custom kernel module or subsystem (let's call it 
Module A) that is not part of the standard PCI/IOMMU device probe 
callback chain, but strictly depends on the fully restored state of PCI, 
IOMMU, and VFIO/iommufd:

 1.

    What is the recommended or standardized way in the Live Update
    architecture to guarantee that Module A's restoration happens
    *after* all its underlying dependencies (PCI / IOMMU / VFIO) have
    completely finished their restore processes?

 2.

    Is the expectation to rely on LUO (Live Update Orchestrator) phase
    notification callbacks (e.g., late restore notifiers), Driver Core
    mechanisms like |-EPROBE_DEFER| / |device_link|, or something else?

Any guidance on how cross-subsystem restoration order and async probe 
dependencies should be handled in the Live Update framework would be 
greatly appreciated.

Thanks,

Yanjun Zhu

>
> The IOMMU series builds on top of the PCI core support (this series)
> and the VFIO series linked further up in the cover letter.

-- 
Best Regards,
Yanjun.Zhu

--------------w02yeVEA7OyGJFRzsrh3hdEm
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2026/9/22 11:53, David Matlack 写道:<br>
    </div>
    <blockquote type="cite"
cite="mid:CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">On Tue, Sep 22, 2026 at 11:36 AM Zhu Yanjun <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">在 2026/9/18 13:06, David Matlack 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">Future Work
-----------

Following this series, we expect to make further improvements to the PCI
core support for Live Update:

   - Allow P2P across Live Update by avoiding resizing or moving
     preserved device BARs and preserving all upstream bridge windows.

   - Support preserving Virtual Functions by preserving SR-IOV
     configuration on PFs and enumerating VFs after Live Update.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
kexec is a foundational step for minimizing downtime.

As we look toward complete end-to-end support for DMA preservation
across Live Update—especially for VFIO device passthrough and dma-buf
sharing scenarios—IOMMU table/domain preservation becomes crucial to
prevent IOMMU page faults when devices continue performing DMA during kexec.

I would like to ask about the current status and roadmap regarding IOMMU
Live Update / KHO (Kexec Handover) support:

Is there an ongoing effort or RFC series for IOMMU handover / page-table
preservation currently in development or under discussion?

How is the coordination between the PCI core Live Update mechanisms and
the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
restoring domains or handing over root tables)?

Any pointers to active discussion threads, RFCs, or future plans
regarding IOMMU participation in Live Update would be greatly appreciated.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
The first IOMMU series to support Live update, can be found here:

  <a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/">https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/</a></pre>
    </blockquote>
    <br>
    <p data-path-to-node="6">Thanks.</p>
    <p data-path-to-node="7">I have a question regarding the restoration
      sequencing when module dependencies are involved during a Live
      Update reboot.</p>
    <p data-path-to-node="8">For the standard hardware/driver stack, the
      sequence seems to naturally follow the kernel's early initcalls
      and device probing (e.g., IOMMU early hardware handover -&gt; PCI
      bus topology/BME preservation -&gt; IOMMU domain attach &amp; DMA
      ownership claim -&gt; VFIO/iommufd cdev binding).</p>
    <p data-path-to-node="9">However, if there is a custom kernel module
      or subsystem (let's call it Module A) that is not part of the
      standard PCI/IOMMU device probe callback chain, but strictly
      depends on the fully restored state of PCI, IOMMU, and
      VFIO/iommufd:</p>
    <ol start="1" data-path-to-node="10">
      <li>
        <p data-path-to-node="10,0,0">What is the recommended or
          standardized way in the Live Update architecture to guarantee
          that Module A's restoration happens <b
            data-path-to-node="10,0,0" data-index-in-node="125">after</b>
          all its underlying dependencies (PCI / IOMMU / VFIO) have
          completely finished their restore processes?</p>
      </li>
      <li>
        <p data-path-to-node="10,1,0">Is the expectation to rely on LUO
          (Live Update Orchestrator) phase notification callbacks (e.g.,
          late restore notifiers), Driver Core mechanisms like <code
            data-path-to-node="10,1,0" data-index-in-node="150">-EPROBE_DEFER</code>
          / <code data-path-to-node="10,1,0" data-index-in-node="166">device_link</code>,
          or something else?</p>
      </li>
    </ol>
    <p data-path-to-node="11">Any guidance on how cross-subsystem
      restoration order and async probe dependencies should be handled
      in the Live Update framework would be greatly appreciated.</p>
    <p data-path-to-node="12">Thanks,</p>
    <p data-path-to-node="12">Yanjun Zhu</p>
    <blockquote type="cite"
cite="mid:CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com">
      <pre wrap="" class="moz-quote-pre">

The IOMMU series builds on top of the PCI core support (this series)
and the VFIO series linked further up in the cover letter.
</pre>
    </blockquote>
    <pre class="moz-signature" cols="72">-- 
Best Regards,
Yanjun.Zhu</pre>
  </body>
</html>

--------------w02yeVEA7OyGJFRzsrh3hdEm--

