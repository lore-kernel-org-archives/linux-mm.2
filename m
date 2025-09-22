Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5349ACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 18:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70928E000B; Mon, 22 Sep 2025 14:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48408E0001; Mon, 22 Sep 2025 14:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FED8E000B; Mon, 22 Sep 2025 14:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 804FA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:03:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F45EC072D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:03:17 +0000 (UTC)
X-FDA: 83917658034.30.FA04E01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id D9AD04000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:03:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ec5LT41V;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758564195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiGw8qndz230qKn8LjE5/t4sTzv4HP8ia3a14ARun1c=;
	b=j/QbocSE5GWOe6l/1LDipsdnyllvC70BM5KFEfb80PD0IqPUg1oqSNOD5x3MIu6f6sCpaw
	juczPQAYchlRDzBHtRKIqebSE90Znk3FBWjTrxwr/Q9MgrVInaPWJDAOAD/U6skibTnUuU
	w4RVxR5xGENcJ4gehaekkAPp8Luo3WI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ec5LT41V;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758564195; a=rsa-sha256;
	cv=none;
	b=DtABdPCqrh6m/61Q3vQfa3Y7NF0OCLekTcJSox80p/BHLWqshBFoNYEF/m+1fPylhvsjEI
	vFO+VePigrVXHwaKGuI9aBEaDay+OT2lhPH0o49D0R09HElsicTL4Era2CNUCJZKcbAyfu
	QwTlc9YWlU7YmQzpeGAUGd1jPqUdVdk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758564194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eiGw8qndz230qKn8LjE5/t4sTzv4HP8ia3a14ARun1c=;
	b=Ec5LT41VpqVb98nEAgExKhePuZoPQFIoATBck6NVBOdYkdnHOY6+sfiTHSRvgbsi0ImpyY
	q+fN1f3wUlv01iVp6MX4bbis61D/3rkIzm0B1mKenC3uGRLIIkSAHXT785OvCdo4OnyG3j
	WYFfmlxqwGPjdxk8aqx/AV0oquSHVko=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-BLDW45dZNHuRLwb5dfgB5w-1; Mon, 22 Sep 2025 14:03:13 -0400
X-MC-Unique: BLDW45dZNHuRLwb5dfgB5w-1
X-Mimecast-MFC-AGG-ID: BLDW45dZNHuRLwb5dfgB5w_1758564192
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-827061b4ca9so852263585a.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758564192; x=1759168992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eiGw8qndz230qKn8LjE5/t4sTzv4HP8ia3a14ARun1c=;
        b=ERVM1wg0nhuH+uyCz6dlSNAmt3c+McdngWlr3Ak8IEHapj+fYC/EXKedxco9WUo+0P
         2S3d8aPg8efRXcNOk5Iis2bSr1iF9LGtHn2KoYNo5qj54Y2h09i2CvYtRIQ15VtvRZj7
         HTD4aT5fqHP1HGojNnoWZCsc6/KWnvEQOxT9CSz16LLOND81/bqi3Eu2/mlMrfkVBtF6
         UUbwE/GvEpvkptnfPW3XzbvkoMowPp3HlAEhILmopqpW6UyR337j+BDawXoepMFKfKPU
         SYto9xvl2Sa1h8cJ1yxLHAsGCa0FOxXMIAVzxZykSQr1Z6eL8IfiUI9vINDIBmrjilBn
         mxFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbsUuOlVPbFY0kCzSd4DGr600ZW3JHLFaNA+2PmlyMNKS19qn+rI6MqSeJiPhsimkUAplL4DGMQA==@kvack.org
X-Gm-Message-State: AOJu0YwE9dAW9TXxRI7Dtoi7aizu/GFBafK5JTd1omqo1+xpInsgTlqM
	0owh3Wk+QS6w5Zd3YU65oc6HRH4qb8LGmLjYO/sjrvEBVQzqeddz+9ePMIbOSGVG3HQiTcA8JWA
	YbvsZl6M4imPzx2FuKFjQeElOBoJKoNCUslMoova/vfLqqpgZ81ea
X-Gm-Gg: ASbGncuYrjqnLa5IAxi3Fda1oX2pOH/JAZ40+gg11ACBHzXijHur0xpAEilA/HPK8Fs
	JMwb2eR9agY2TvxsV0z8IDvaoM07bFkb5ulgAzb9Mg55QRpPRG3XLDkpWoY8aa24hEuPkukYSat
	UNpWvlZFAyZKrK4UFuhPQH8tP/unxts4cyfjz9y7s5tt0d6BpeDr61ZQLdM7MQP8Tpjp2WCoYO5
	D2CGd2GMILWImx9g2tbIrdfDltCjmFPvyTk5xZ2hxp0eMjs2Gv+APDe0AZ5O3TWLhtSvZSojJGj
	QHz9VZebTpEbn/PO4s0Uo72Oebso+7GZ
X-Received: by 2002:a05:620a:832a:b0:828:aff4:3c03 with SMTP id af79cd13be357-83babdfcf5cmr1258674085a.61.1758564192024;
        Mon, 22 Sep 2025 11:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu1SuYkWfMcMDPsDrtqIfPiA7Bh/dZJ/L5fKT+blbHI9wKKzeXLIdyTxlnA7RLV9KO2wzu9g==
X-Received: by 2002:a05:620a:832a:b0:828:aff4:3c03 with SMTP id af79cd13be357-83babdfcf5cmr1258653385a.61.1758564189826;
        Mon, 22 Sep 2025 11:03:09 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83630481f2csm826194585a.35.2025.09.22.11.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 11:03:09 -0700 (PDT)
Date: Mon, 22 Sep 2025 14:03:07 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNGPWyNpVbsN71R9@x1.local>
References: <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <6a6c8b42-ed13-4fe2-9ef4-5641b81ed2d1@redhat.com>
MIME-Version: 1.0
In-Reply-To: <6a6c8b42-ed13-4fe2-9ef4-5641b81ed2d1@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Rmp_f-VUIeL2NRDEVpFerIW2qBr5Vg-YOPGXkiWd-xs_1758564192
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D9AD04000D
X-Stat-Signature: hqkwzona9wr79d6nejmyyiz19fkehfut
X-HE-Tag: 1758564194-122939
X-HE-Meta: U2FsdGVkX1/ktzNk0CZsThYi2XtZ07dIy9loegTZo0FvoxKknPvGQBVJgpEkvhvxiFY4zyGcJyMvg0L5HNW/F/jU9U03gJ8x5YECoFNEXNrQOJUVqgOv2F530dgP2u74TSB89qEicZeHGTJpLJ5hDcxURoN+f7HQTfRW3ZlOnxi7ltlmlyhXp8OOKE2caEToTu1s/0P5w8JBbMBzNaVs9BzsleXOqJl877MgYyRH/sV9RGmhgE1cD3TbGc5gTtMbUH1HEJFzO+gUIV6V3ka1W3EhWG9951aIAe4B9MgwyTWDcFHEsG0eYNVfHZSV3+AWxaLAv+PAZLZnd24/I/GOE3JrRD/Eebb0TbjdhkIc4nD+BQeprxKIOiEvfEu/qBJLJCJS8AVQWQeFu/0J+HwhZlT48oBgaeSQXA4RHqCcmukJ/rm2AxFe4jL+LTjvHsD9ehjKxJxI/qicOVW+IkJm52OCRFLMYdOAj7P5AW4A7YILJXX03ODf1FFzXIc2Fw6zzw+Ck5+fNGyoeOlPgU8RuShAL6uCVZN0x0b+i7kZtnGXjQRKTMVkus5GDkg2khX4agxO+EAPPNL6/XzQMJ+x3pQsjvYVeNbwWQxa2KrUkBkISMLWBEqt4mIDPyf86bE0FHX3tDvt+8D2GJecrSfsfi7j0aUpFyDGX0CWctOwFaJBkS0UbA8nec/BzUhMDSlUTU3qRZuOkm3PHmqkpSd1LO3dmCz1lSg5vqliTzfVNf3RsKhwGSk4TiSFcSJPv/MzEMAMP8uCbcJ804Km47YtKSldW5EVFGsq9fir/fPNk7lyIXre/Jd/2Xa/qJI/rFvslJjuVJuVlB8HheCLaF1WMPU++ZpDV3zRuZfSyYwAEJIO8oP9T70LLH3MPVAmAqVsTrF1LSSXbz3j9mSopcAznhSjgBEXHWUSur+4i/JWcrycpPrdAzDzIPsEytqSvwLphgUBXvtp5Zip2bLvsrx
 B49KiFic
 NOC9ykKhIAfSEhd37WRX5to3VCxSKb7MKkyGmgQnG5CfBU43WthIxQVd2RMwaoMbIRb/m3u6pa6DXIxfiAauhwUg/X5bunGyNvpoMHl03XzXNr1K1+q7Ho7BZyQFVzlSLNe6u3c4YuHqmHO4XgoI2OOPMfBw/5dihOOmp2xZE8SlX+OnIoEwNRDALuNi9Xu1qAWwG8D6pfhrW+2DqvzTokfTfEeIMJKWK01h+iri629zg6HWNwJcz/VRLgzsD5A8BDcExYVetjy2BC0Jki2aSMarZV4tlkP6unBiBKUzzFT4eCOX0H1eVSU/19uWkFPMcAPSFsNhe9c/B6NLTt51Dt/az84KACVSflH55WyHU3/QlENwXcNTipclrKwJktmP1k+71ww8L7XF6rzFCwxziLBM1dQWPXW1OVeS5ladeKzGh1E55m3KHwKg/Uys5ksm0NU3A7cRbvYQ6w/MDsn4OzpRTkB3YILc7fv4JA5dqZdxnUhr0nMxVJ/8KMZmwnP6qptx+dd3e0x2qpGvJH5UhAMUOiXTytdT6XQVoH2wREYzBQ8lLGVtj+kCmylUemhqAbRVP6GPeIGoIVNl3mazJafYvoMUVmHOelON+SPoxZaCcHTA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 07:20:50PM +0200, David Hildenbrand wrote:
> On 18.09.25 20:20, Peter Xu wrote:
> > On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> > > Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> > > might actually be pretty nice.
> > 
> > I commented on that.
> > 
> > https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/
> > 
> > That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> > make it extremely hard to know when to set the flag, and comlicates the
> > fault path which isn't necessary.
> 
> I agree that FAULT_FLAG_USERFAULT_CONTINUE would be a very weird thing to
> have.
> 
> I was wondering whether it could be abstracted in a cleaner way, similar to
> what you described with the "NO_USERFAULT", but possibly taking it one step
> further (if possible ...).
> 
> In your reply you also mentioned "whether we can also avoid reusing fault()
> but instead resolve the page faults using the vm_ops hook too".
> 
> So it kind-of is a special type of page fault, but the question would be how
> that could be integrated more cleanly. And as you also point out, the
> question would be which other users it might really have.
> 
> In GUP we achieve not triggering userfaultfd by not setting
> FAULT_FLAG_ALLOW_RETRY.
> 
> But it's rather that not allowing to retry (drop+retake locks) makes it
> impossible to call into userfaultfd.

Right.

> 
> So not sure if abstracting/reusing that would make sense.

Direct reuse is unlikely.  The current semantics of FAULT_FLAG_ALLOW_RETRY
is very specific, meanwhile handle_userfaultfd() actually has code to warn
already when it's not set..

In this context, jumping into handle_userfault() is already wrong because
this is about a request to fetch the page cache without being trappable.
So if there'll be a new flag, it'll need to bypass handle_userfault().

But then if we'll need a new flag anyway.. IMHO it'll still be cleaner with
uffd_get_folio().  It then sticks together with the uffd description of the
memory type when one wants to opt-in with MINOR faults, which should also
explicitly invoked only in userfaultfd minor fault reslutions (hence, no
chance of breaking any form of fault() either..).

Thanks,

-- 
Peter Xu


