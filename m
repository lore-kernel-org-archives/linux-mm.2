Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E032C5516F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD146B0088; Thu, 30 Jul 2026 13:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D6D6B008A; Thu, 30 Jul 2026 13:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D926B0092; Thu, 30 Jul 2026 13:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224416B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:46:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82CB3140213
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:46:29 +0000 (UTC)
X-FDA: 85046172498.19.0904A66
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8ECC24000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:46:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X+6U6yfm;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785433587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
	b=hGqGXNQGCE5sA7fWHa33TUZv55Qa3DazVVdQneHY++svJ0rRuBb3j/QrWwI7jwL8sNxvlp
	bTi8/azAURdVsbi/2ts7SsiicmVcy6tXd2cTpAcYDhSdI18N9rWe3t7EXm/oeJE5SSfDKO
	YSaoAl8nHR8IFcyp6o1tmNnURTf3z58=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785433587;
	b=V66VhTXk80EtOOne3gc2vLkCjXbfe5o4Wn99DoTi1v7961xNo2Q7uYeZrmwoaaWg3YfEb2
	1b+Isd6ZMVvv+QyUQBNK9cVkBpsVL4rYNRLzY6NVzrcMyTFFTCoU1mm2fNs7R+HS8RZF/e
	BHjg3fnJXaYLTFcc2szp9FhL7zJ6G7A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X+6U6yfm;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbb85186d43so31637a12.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:46:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433586; cv=none;
        d=google.com; s=arc-20260327;
        b=YHkNEvbI1TUzsZrPgwu+IKrWVdsdAakcOoOFKVgkh0reZ9zmKS6Mbcnls6dVAL22g7
         JSeeOGq+Qw1A4GJRpssOXkxFifQbhxfHHG8ZOrPnzOiNLB72fSMJQhIZrih74kySvTvz
         N0xBz4AbvZfLY22dnbjbI5VIWQeJkcwYV73HNJ197wTdurGBBPf3gfPcocjtVLCTrCFp
         nSBKScgRD/c+6dSj5m9j+I2m8G2f6FDqd+mvBFPJmpTulAtLxcZyXcsFA08V75f3AThw
         uS0zvQRH3GeZE4QKKxLEgkxe+vzE5/HUWnzumikrTDqm8ez1dW5+fGB2CnTpW3Jp3pDT
         KCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        fh=ZtaJK/rAQTwYElew4noZtLvjcTYGlB3qGnCk2ykzSfs=;
        b=X3Ku4oI7jCp5hdZmvxX6Wl6eaSFVs0VDprc/sUOMeJVw/MP510vRgykSKcpNm6gUmI
         l8AvqToyn4c5geRoBKMRb2YV/LgKHf47s/oFo5Txfq3OQAzQ9npKF6CYx+NZfM+Ob/A8
         X7UJBJgRd1GLj8n3AHjS3QajyCxL+oWnkqLOel3br2lYPcNv2SqODFPLVtcuZ2IjlyAX
         SX5dlNcqI8M1k+v4GRfWCyEHwzN0vJb1Mf1TxWgM7AFkTJBmejCCX0or6xqC/PY2wyc7
         prT56rgPB13XVh4X12b7yOE2GSkdukSUmne8p2FBpH0wZYC6EcDICn/NOVzgjDfsFgn7
         l6oA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433586; x=1786038386; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        b=X+6U6yfmJGrhU1a++aD/qJi43tISYav6Xulq2QSsMm8TCZa0/62pR7i83RrYlJTlAa
         Fm4t9ELw6shrLFPOCmpce/jB1geuQ2zFfvG11Lh5VS483B0G5+NmbaKi4ukRsMIAI+1r
         ZNk4oDFqK4/By6yBPdPP+1DwaweyyO/Vg+ExrUjp5K78Tom1tPMRbC1rLY5jlfaPdpQJ
         DSYcsTBJCIcAFvdz9W0DTtwLzi14D0CV/lZVCukdIJnxt1xobHg8SqDDZD4whrWyWpYH
         ZJ066WmoDqT0xyRzb7X3HPhMUnU2GfduiMsUrVnSEakBcyMiQrVvOIa+WswcP4KwLY6+
         2v9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433586; x=1786038386;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UOih8CBVKjn02CmrfoiIHS5zm6Wg61jRZNK4KLcmhAA=;
        b=PcmAi1lg4op7oPFkXojiymAEfjYZwX7y1fBZIQDiu3rMoxHKgbRFNmozpnBfoPZvE4
         loXPf6Myx1SEX3d5qzgJrveVxfUsmXTkbQa+jtnStOV23kWdZhgotQ63CkGgjJHtBA6h
         e8pa4i0dHDMZ8HPEP237+ZK4w46SBgzSe4FrYHYIgIy129DNoGNkb7QQMT+ANVTJqX+1
         Wy1lL35vgwAkXnrVK6vT0wlIf1rtn8DBgy6N4mN67ddQWutbgpe0rnz/nWXgmNBjB5MA
         V3oBdpdYnqhojW//7JxFOdMgambmIqol96cQf5QNavEFYNjb753OQI6SCmvlVyDo9aY0
         eHQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCuxTwhEAC1Erol7l5Ievs7mILyw/q8vCFoV46E398zXyh8eJTL3OWJ1VUSE9zyvpOCvJnoSz9sA==@kvack.org
X-Gm-Message-State: AOJu0Yyw6INnuORUP+vfHAxTwnXqtlLNb0nQTwFyIpB6G/FdnPZr6e05
	FPm3x1OEK2pCeT095ROmFXwqP1vmufUbPb3EivwwJzeL91pGcXWnZuCrkmk+ZCyNe9P7Arx474r
	KEyRXgFuD9ds3jDY/iQPBDwFstk6euTvJ+zXDZIYs
X-Gm-Gg: AR+sD109zKmjUZHv3tduPoCZtnx95tKQwqBlBy+tSNLrKRUbI0D8u3ESIG4BLAH98le
	Hy0hY+vioS5NmY9tw48DAAKlf+sKX1QmvCJ5jWKh09z60wyX410qt1aIg30XoNv+9hgy4ecdFHw
	0I2vYRoIDSZCSCiJgdEUfsG4vQE8wt1xqQk0GuRgm0kFgR4s6sDQcs3vh3JmrJLkNjBl/U+dIzs
	cj/V+eoXReSM3w3XAXUR1ievPpx9xP7HQGlajwyD3/6uOtk8Hoq8/EM0SKvZ3SpewZ/WvQJceEV
	Un9DdK/r2LZcO53x4wLvmDTLIsVmGILE5yIOz0rjqscSxlVdy24XkVb9egfqrVyOQUsD23oOuic
	QyrvsxiXARlx87uIvrfDgaoPMlduaRN8vew==
X-Received: by 2002:a05:6a21:e8b:b0:3bf:6ac8:8d29 with SMTP id
 adf61e73a8af0-3c9006bb981mr3748982637.21.1785433585760; Thu, 30 Jul 2026
 10:46:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:46:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:46:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 10:46:24 -0700
X-Gm-Features: AUfX_mxSA02wZmCDGZHkTAv1sqG45AQrWdNvcUlNspdo9IevcZmmfeKZDjs0tR8
Message-ID: <CAEvNRgHvBTKaG4G5J=sMFGYepEnOFaeCBtjkzN6xmGtZ+o6XxA@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8ECC24000E
X-Stat-Signature: xxcbq696y7uonbem5skcxj83ugj179ec
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785433587-170348
X-HE-Meta: U2FsdGVkX1/EZ3CH22HuzI4hoVe0HGBmSsqrDLmIOlRTiJuG6i3a1DKw9/RN5ZnaMn0AtS8f5+/J39c8y53fC7RtX3sKxoz36OXmC6XmJtoLQAJl+WGLuVZ0ZLZaWNNDLzOvRAkatOHS49JjNH2wVVErqbG+3LpZbZSLfLK12IwgqdPYMYIHGTwIIcyOpF2ahX4hZjcjMtwxZy99DOcaIhXjFzG/FPOYV9xvqFnpGRtn6y/9Hr3Pfj9DcaUTPXmBzYPfuV1cml1K330pbJdhRecSZg2+zqtsQKGQgIv8w8NN755bU9d84OZHc7nkq44e4IYW+Em/2XQ2AtoOdZff1BFKflBDI42IAdd15arpsC1kB/XJSPmuofRsp2d0vFYxfnAUjY11C/fqnteoaBXElaU+LF618ZshmWiJoATFD4dPHRxT+kyWwwJxM1CkqQIYfr4U229U7G4MU2mogWZ/PerQ6V8LQSqT31P5/tEgRPxnpoGKVaKXZ7Gzgj3+bAHgjXaCVRe/z7KA0sqiMeX/CUA9FdWFPxhYdnNAY34q/LFHrWNtBYcK6m3jfbLjjwnbrt5H+nZJei5MR8x4O6jz+xgYjhiUE+VdBpss/lR8c/MCPavfGecJIxku79XVPujiiJfBi5s0c8OsDlsXCd23K5X/TYB7szPEBfYFic3CNA4NltCiDqmS9tWKjIU5BbKnxlSPXk3TByi7Cmk59HrTCwuE744vJ7924RdUAabJcgylG+0Qnxzyo9ADqlksWt/xIhW4r9HK/6FnZ1L5f1ttkg+iX285gZsm1SCVcoHf7ot5ZpbhiwICJtxuzPrDa9d609b+RZEgETuqyeN4ZcXHrZRnI46eF5IwN4k0x6Rv+2KNnPsy0B5crfOOa+6A9SaFS/vTBniq/+BjuzV3ESTJ+DyPxC/UNFZGMnfvWGpY7K1rV7ceP8EUwdnvczH5YIKU1NCxMZcqOsLcXUUcZNw
 NIsU5tEi
 h792cxy/eWl7eP5yNBSpC//I5Sr1o9eONm4Jwpg/rHwY8MPXYyuxX/idsMl5XDPEbNBvN+WJ8GvcGGh0fOI6VVPSeban0YDppywDsZdzfgA6XX6XHoXk/FRgf7+78TPOqIgF1ityKcjvpGqRuKpNps3yPEWDJiVTZc6jDiWyigjGMVgGJcYKZ4E+W6BwvrcDtE/XebcDpb4MXGX4fMz+0ehPX/O5uvYT/CCiIr3s23cHgbeWj0Too5c9fusiMLfObFL8c1T04g3hOIN/A1wl7B1O2NP5PtvEbN4hU9oYEZoUe2lbtkfIDsn7J1UCYAhvhXsBWpaQh/FqudSMJL6NyLCY3dE9XKgLPGKC5A/e71mqa7eb9RI+HlQ6lpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Introduce kvm_gmem_freeze() to freeze a guest_memfd inode's mapping,
> which prevents fallocate() operations and new page fault allocations
> during preservation.
>
> Use a global SRCU (`kvm_gmem_freeze_srcu`) to synchronize freeze state
> checkers without incurring per-fault locking overhead or risking per-CPU
> memory exhaustion (as per-CPU structure not counted in cgroup) from
> per-inode SRCU structures by faulty/compromised VMM.
>

I wonder if everything to do with freezing should be gated behind
CONFIG_LIVEUPDATE_GUEST_MEMFD. What do people think?

> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> [...snip...]
>

