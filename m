Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0024606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=asbBGAqH
Received: by kanga.kvack.org (Postfix)
	id 165DF6B05B5; Mon, 26 Oct 2026 17:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ED16B05B6; Mon, 26 Oct 2026 17:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054986B05B9; Mon, 26 Oct 2026 17:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5E556B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:14:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F8488087B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:14:15 +0000 (UTC)
X-FDA: 85366030470.25.E17EEC8
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87A57180007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:14:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=asbBGAqH;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793049253;
	b=VrnKqg4A+8u2vQ0t351FBHn3XmgWFkC9neL8HgHpQC7rqwhQwbcietJLKcvfwMOEGptE5z
	8+oxORJcszaY9n430sDqPm8UQO/PGnW7rICfobS83WdQ8mt7F78C/xhKRWr5M7Y5Q8eaqb
	2RB5kV/oGC9WsHzEUSL3EXq+Kvw2e00=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=asbBGAqH;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793049253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
	b=FBZG9Zu0JxDKan6n3xkiF4RHWczS2ZcbQuoog8z/zj1uielMDOcOWm0VPCSfvZpL+/SR1r
	Vjv/rV1rzPn/QofpuDQ3kgCpvN8B2YE+BCnIXyVYHJxjiu8+CZ2E0rSF7adi5K0P0MSlkj
	U28SSYfiQg2CuExj0kJHygvbm0j8WnI=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a070b3f44aso1227275b3a.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793049252; x=1793654052; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
        b=asbBGAqHoL4cacXaNEhxGF0kMPojpGl+6H1whiQ8cQsjGgRElNTh0nqfywGcwHv41M
         7AwMeaQa0T1GvTdYhhNlBpAXpAOqleOebZp+U4wBKcLZVaMeSCNr8v5qgRS9Boz7Fe33
         0tBwmyKaZGfu823pqPz6uf8+SvRHmmVzGVZyaLE8MfNcY+PSiI/HQeU29urxH29Z3VmS
         Ath3OSnP8BZctXIpaFKtq8ybT1vejoMf0+ujv+j0htiV9mvi3Kvzid9oKntBydG/syhh
         S4cCTSYh9BqGCBczA8IhhRLBEmOThVgZiECv78xMiisTRovVzDLXeDVR0rJHDoFiR9Vp
         3L+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049252; x=1793654052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
        b=J28g1/YWT3JTJ+8Tk4R3rDbKsaihtMXwab1fiFemusRBmvdLhudsKvAVV+a6xYylpa
         XeME+qwsp86sW/G+8V1v4SodYAOutiC582zvnUIG9DxqhBgGBTty7S8WlbvjmrBr3MBv
         crhCfWDv319E92bKUrkLU3GSmxxLc2wytYcz641ktuaMFrfREcKRHlGIgsCT0jt+/COl
         9OpVdLDwfZvbQMemgsUQaNTqeTVF7Hvgxt+Yglw/qmzhp0uztlejm7f0GlGnIfMPzwGV
         xcCrJ+l3u0y17YmCtXeBj6bQX/DseUhvBxOUNUF1Ma4vkxDuAYHVhdSTwKpUmF4/XKG1
         DThA==
X-Forwarded-Encrypted: i=1; AKwUvBzGE7E608PNhUO17Mw/BUKOQiaqohh9ZbvRasgOFFZFkq3GnStio/qsvnjKpg/+rqu4zulQILZChw==@kvack.org
X-Gm-Message-State: AFq9FYJ+y3DkmgcKQdE3sQP+YUb+gbo/lPB/XQoBUzy8OxCPXum3vIRw
	IYs+bamnninjrnwzoiVRrFP0G3qCpnzn81gsvbu8VtdvADbM7uASXR8OJQFMpoTsnA==
X-Gm-Gg: AYBFou18sGx1Tr8/SA6roQxEf5DFryOYkXVga5jLPy1NTWxxiLEJI1DfeSRZeNzBaiC
	JQoij/VTZizbG6M3WsvonPorVPAQ3P+JAsm5yUaEGzl7piQwRlRSOaX+NUDAzxqLG4p23VBjKK8
	MR/MON9bSwICjP67WqGhhIWM7FlaKepdXarMcC9ei+7ZMj4lkVfk6DCSOC/u4I6zxI+2d2UTySx
	fCm4Xgv9tvAq6jzZZ8fvkTWXLyOurcfEUNhUULZuxsXmprcEL3AaSH7T5uuf+9iJgAv8GvV99c9
	d89KI1/1Y7DOuCAjaUy7mkh7AxSzIiXzwPHoSrHTDRH/AavEP0xwfC/JULBKJoI/7TVZBjex4f2
	GaMm/l0uUOCgf8WXMbz4zLwwSARFlnlWb1mh5KLq+b+vqhgZSCmTqVZJD/0FYf+Zo0blG+dJDOn
	R+ONssV8yZccmjdVijiWVQ/lXyBYw0AvoMpN/qDsRI+YSPo6Iq8KeZxfy+Ua/zaNM7/dW/nQ5hW
	RkMmrRDilMEN/uCp+DiOH9Sx6WvO1XY+qme1rG+9Nk0KLKZTS88KY3CENTYOwH33GYioJ8mJueL
	zW+2FaXroU1tEkhUTAVx+ewmw8e6pk4qj8RKxx9CcXM=
X-Received: by 2002:a05:6300:6bc9:b0:3e2:3392:53e7 with SMTP id adf61e73a8af0-3e7a1b97750mr5308652637.0.1793049251805;
        Mon, 26 Oct 2026 14:14:11 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36b372888sm1666157b3a.30.2026.10.26.14.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 14:14:09 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:14:05 +0000
From: David Matlack <dmatlack@google.com>
To: tarunsahu@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <at_CncIPYCxOVkLo@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzzew0el59.fsf@tarunix.c.googlers.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 87A57180007
X-Stat-Signature: kit381u3hdew8r9hx9rufjpaai64jici
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793049253-477379
X-HE-Meta: U2FsdGVkX19H7XD+SB7YnQIuyzsTqQPWSq319aBUcWfuAcF5dw5XCHqQwTGwxo0An8MxkhncdVCHcKE1/bvErpEvZ6xzo9pI/VblluaXBA4hUMoD/UVCDr5jUIRQ+Hya4MNONYcZeLoy65VxJWFaApj9GCjS3uKqvoc3eRDC1xVN7NsKiMkNgOdifCwGbL5XZpUSLuH1YuI7C1/r7TQAzIwmeq+mozmJdgSjscrMwHDI3Poy9wEwSFTlx3IVnRw/6TeuT4k9Qf6xsykTIOP5V3eG68N3SJz0p8f9SI8j2G1Izr7kzbtob2uGBOoXfoZYVid2elFRbzK6FzGPAtJwBlvnmdASRK0NreWp1oTznXJ8cULdXCw+FePviWmeER6JitglaxcXFZ5n7GRnGmwGIWvG8jiNKkI5rbJHxhcTF58EtCrHTZ81arcvKa5aDQxqm/etF08zUYhVnDZtT7HNdtW/iJb5Sp9WRdcADCZthoqqApzFJH+EozqZO65NT1EV3vZ4lpE2oNENazJ3N+eFy6ir8us/wSDnWuEfkdMa9ecS2FvzvFWoRtLLYoq7K/4wtaCwwB3feCMy0lcnAN1LQi2ZoTo8eLKfCy8iO7hLmS8TiEmulTxW+gRHjtk/WFgEsuqdsRZSIZFUsoE+7+o+9ZvxDFOXsQUZAaellamMg6lKiwBo47nMaW85EH+GaCuyC0JkWeuS9P8KIgSSJLxPmpDQ/vrNdSxbFldUqcUztnq2HSBIdnrpE3+p9WRvWYxmT/14jAxO0i8s0RyLIxjAAgRmeVJVsLYRSH/WAOEoixyEqZ5Q4hwQ5VFSjNMd6Btx37kdW1wdAxvo/Fgklfilaj3pJL13ZOa4Db1r9IjAxqhwHpHp3L2+v5DELaraKJW20YcpCikd7dUppSmsyy7I06ehriUJ/u0abkGU5R4ZvIU/S7qd9TyUtKL3i1bWjuv30jCRbVo1lhwmkUEwZty
 hnZALn1c
 aez/L5tvOg1RWGAQhFdojNefRlaZ0Ksu731r7xDpq+TcPYsTX2zrNpQcteZDbYnfCXIY1ByNTAHaFdRVjqXHWwo/92NpNAb29bAAWi5tpODzwyh6jt2D+J0Ob9XagGt9DGYnzTKvenYFHWVCPEdjALxvwkQmPzQ9+SYI6WW5WEdxrJaKKMlTMu/44yRxbZ3PlFoXOXAXFzwIKlsTCj2T9d2qDDzPaWpnO01UUjkPSRuLfGt+NJC+eopJlncM74bJ5FOo215MfJvjdD/I+lFP2XM8rNcQJifbvkgEPHDT8bXlQiuUs7Csdr5pG0ZJUAUI/Nqha4piNO+N5RePefcORqaMcNaT08zw8XaQkDKdVpIT/UsrsSu3w98CHUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> Right, Required bit should be source kernel payload property to tell
> target kernel that the payload must be handled to correctly deserialize
> the data. It should be source kernel (userspace) responsiblity to make
> sure it understand the target kernel before doing liveupdate.
> 
> Saying this, During deserialization, target kernel's required bit is not
> necessary. So I propose the following truth table.
> 
> Source hdr  Target supported[i]  Action
> ----------  -------------------  ----------------------------------
> 00          0 or 1               Accept: feature absent in payload
> 01          0                    Accept: ignore the feature data
> 01          1                    Accept: use the feature data
> 11          0                    Reject: -EOPNOTSUPP
> 11          1                    Accept: use the feature data
> 10          0 or 1               Reject: -EINVAL (invalid encoding)

Yes, this matches what I had in mind for the semantics.

To be explicit: the source kernel should set the bits for each Live
Update based on what is actually preserved, rather than generating the
header from a static per-kernel array. E.g. memfd would only mark a
feature present for memfds that actually use it. That's what allows
rollback to an older kernel as long as nothing being preserved depends
on the new feature.

But looking at this again, I think the required bit is redundant. Whether
a feature can be safely ignored is a property of the feature itself, not
of any particular file. Every file that has a feature present will have
the same required bit for it. The only thing that actually varies per
file is whether the feature is present.

The required bit still has to be conveyed to the target somehow, since
the kernel that needs it is the one that doesn't know about the feature.
But it can be conveyed by the feature's number rather than an extra bit:
split the flag space into required features and optional features, and
assign each feature to one of them when it is defined. This is similar
to the required_flags and optional_flags approach in struct pci_ser [1].

Keeping the same header shape as discussed with Pasha:

struct kho_ser_hdr {
    __u32 size;           /* Size of header + payload in bytes */
    __u16 nr_required;    /* Number of required feature bits */
    __u16 nr_optional;    /* Number of optional feature bits */
    __u64 flags[];        /* Required bits, followed by optional bits */
};

Required feature N is bit N of flags[], and optional feature N is bit
nr_required + N (using nr_required from the incoming header). The length
of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
are numbered contiguously, so there are no gaps, and up to 64 features
still fit in a 16-byte header.

Each bit just means the feature is present, so the truth table becomes:

Source bit       Target supports  Action
---------------  ---------------  ------------------------------
Not set          -                Accept: feature absent
Optional set     No               Accept: ignore the feature data
Optional set     Yes              Accept: use the feature data
Required set     No               Reject: -EOPNOTSUPP
Required set     Yes              Accept: use the feature data

There is no invalid encoding left to check.

[1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/

