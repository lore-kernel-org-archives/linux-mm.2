Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBF6CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F236B0088; Thu,  1 Oct 2026 09:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0856B008A; Thu,  1 Oct 2026 09:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D01C6B008C; Thu,  1 Oct 2026 09:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB5D46B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:43:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64C0AA03E8
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:43:48 +0000 (UTC)
X-FDA: 85274175336.10.E6A5E36
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 820684000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:43:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GvcKgqDS;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790862226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GzyFhoA2S7uios3Q3nexzUQFEC9iru05+QnoGlj3hE=;
	b=6UAuAe0KR+uHvnagTF/G0tukI9gEvVAjOFNCGD1GGlvRp54mfH8qy5gwB2h2aCaVmmjSv1
	TIfyqSloA4ONEGHZV6bGyn4HtFx8l1+8AwFhgBrvDm1kGYCpdH0rzwtm+4U9NWWKnOpDmn
	q1+vs4IxdzMbLjqPNUTsl3DhB8wQB6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GvcKgqDS;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790862226;
	b=vpNGN3LuMZX6DOAjMrvGiesokJwDb68GyF1xUr7R9XfEXDwjy+t4TOAbC52o0bqjZ9C3d5
	OFJHEtnpq1mIN4ivHYNj07KejWNkuusNYzusvNY89MPYf4oBvDntI9BPbJv+brO9VO1FEu
	wiSvRHHyK9jBei3clkBlJ2Nptz/3dWo=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ce364488dso10794405e9.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790862225; x=1791467025; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9GzyFhoA2S7uios3Q3nexzUQFEC9iru05+QnoGlj3hE=;
        b=GvcKgqDSu/I+aaFkVJZB4VQToC8BMSO9UoL4WEVmb6HYYJ4L0/IilPbVxP9YPhR0LF
         gZjKdktNah+lgMDK4xayBLZSXaAVmtL7z2NJU6ZEcksRcc4ivoPfy4ZJhNDcO76tX78x
         sKhCWKPJV/4ian/XaFawtuCbe4WRLeyCMXuemy7WmKJmVXDfP7OQNvtnj7tqGMafjpzj
         r6GyAXEl4vsq6i1gLLky4oHTt73p4Z+Wx0J5Dey6EferkjuSxbl9fiEVMohEXycJCJqr
         h25ILaByNWANSYNhwKABmLc+UK4b7w9PzRnAIHRidEbl2b4wCRNUil3THeKbby/Tme6z
         iAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790862225; x=1791467025;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9GzyFhoA2S7uios3Q3nexzUQFEC9iru05+QnoGlj3hE=;
        b=sn9hDp7MQSAaPbwC83v5rRxnFFDejve1A6pRZP3+s1s7TCZ5szZxt4jtz2+Ub4gWXQ
         8oF9Y9H7vzb2uf4PyeAO/qqRgoEDtlSqvY+OE0BlM01qJvDGYxIU0MGbc1G+miQ1Yb+q
         AGRZdRYpXeH4F1cvv4JNDq3togV32xoWcgeUDOzxUskHoFx1mu9pz4hUoe8ZmSghiZCZ
         AbxnK280bvrIj2i7YsGmD1K0Y8AylNGowAtXBaMvAagqCu2P/rF/n4aKu+zI2TbmlrCP
         4f5QipYRFPyJlsvJN0SuMhwVnefM7mgaByvSrtRO79kcicyYQffSbTvoTv+hYcTq5eIe
         yGcA==
X-Forwarded-Encrypted: i=1; AKwUvBylFmbNNyheUZ7K4H1Y37CQlbqVJUnuXpgGOgEDmYBE400AyOz6/heVtd3ZVo+GfvFPGbTbW2U2AQ==@kvack.org
X-Gm-Message-State: AFuF++npxLYItKnwFlERT3Z0fAdpO8PGrKak2WRJI//C/+qk8EIdoqGq
	LK+e7leqwnEZD7jdqT1kcF29rhilG4OFv0Va+knz+LD3O6oUqyz6+QsE925/jXfaDXg=
X-Gm-Gg: AYBFou1D5zXuDJj6aRom4juA8tqgeJyZJp6/kr+Fdp3drTWdUOKH+3UNwxZcAkRWzE9
	vpafrlJdtO5bxFzHrquyxYcnnUAGPFYPn02qiKmkXfD5ekVDFYOmIumGmnq0RHEzhHcNvHpQkMZ
	+RpSuJgcCR7EJUd7xa+0odrSm01n1HWCXYEV0+cNl2fP8R+xxPrcH41XVwloNL5e2woL++KPyOx
	5Mb9wYIJYpzfyuppb/AxP70K6XAsK4N7lIZFg7B66MEMpQrzQglbSVUw2e6p9LJlPjL5YbYYtQF
	zy4RTeoLGUMWKH/GfLc5rDI82EDuI6KneFRGQn+q7df9Sww55//5ttp4Pssy43BPuv9h8R3os2/
	9UK9DrmqcPz15JezLmU3uugLndX2DqTfdGd8fcGQKBXzmQE9sGTzqRzfrZDZNWA8chLV4FpY2OQ
	OLBybi05kYCt9DwIPhWwHy/0EQQV6eyLSnxGVl52wayE4DuCi3hBq2VOI29LUkQA/0V6s=
X-Received: by 2002:a05:600c:4f52:b0:4a0:22d5:21af with SMTP id 5b1f17b1804b1-4a022d52255mr32632575e9.15.1790862225048;
        Thu, 01 Oct 2026 06:43:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:7dd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a023ecef86sm33062845e9.3.2026.10.01.06.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 06:43:44 -0700 (PDT)
Date: Thu, 1 Oct 2026 09:43:42 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
	rientjes@google.com, fvdl@google.com, jthoughton@google.com, tarunsahu@google.com, 
	pratyush@kernel.org, fuad.tabba@linux.dev, David Woodhouse <dwmw2@infradead.org>, 
	yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
	Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com, 
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>, kernel-team@android.com, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 00/17] Allow guest_memfd to be created using a
 resource (pool) fd
Message-ID: <ar5iaaLcyz9dCXQI@gourry-fedora-PF4VCD3F>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 820684000A
X-Stat-Signature: sobykeq4hm5g3qktaoepm13sdm7p6cy5
X-HE-Tag: 1790862226-564553
X-HE-Meta: U2FsdGVkX18Q0oY3eifhMoAYsfw2/u2aEaU3F4IGpL0/WWWPSQviA775u+ipW9aLf6RuMjdFa/sImed05DWiy+dBw25FtSaASx7iu4grxCo/TLbEu/pxsNUH9Z//WvS0oyRGbLllaJhdq/56WX1VaE3daqKZqYN/leJRG2s2Go3ieySvYji3SProd5nS3/wcARwGdtofPY49b0hD8DZFz6rRpMHxcCDTSvYFTdhKMRaPix3SiFUo5fi+Zh+Rk6S70wczWTE+lRKv/t5mBHvJ2FzVFJaPWMcdf5uoMfM+WyLqBksozpfBGz4CMpjZGqRE/78pfXB6m9kyTxvVI3AkNsxZ2r7+3JNzZQTb9asz7kVvu1JfjXVrPdYlaQ21lK/fFqv2BI6OPJenxJaJ+7AEAqtvKzaTEHFGT8CUkIMXWWD/SgUTSfXVnnNZaNZOUWeK4js5nIuf2ZuneK8VdXOF5Kwdn/jz1oBTIm+whed7fsR8foEhSSVbjTtbhu7WZqW9XOruSSqH9TO0DRPQQLP+2UuFcYC9ekG6b2QCXtI6EYrNNU/7v8dHhYFjBSe2IG4pFF33tWjeJCvWrulpz/nRKBSEwW9C16WmX4bPDh6ODW1iWi5R5sbHWz5Xka5Ga+Ueq+J1H8LBWj2LM4gFJhSv7K0nrAnafzsoqW92Y0crkjNHZgpht0HFul8/nZ4XJvEOpLkXJblcJo6aCr9oZhPcWuzgDNui35Q0XrlHT6YhPzHOcREit8AAbPch2bPKlInaQxQxayTKCi4pib9thts325rgkmT5Ff4PhySRBE6XeSgjk4LYvITFgL9Tlz0Z6wSLRyjLeAtSk3TJTC/PHcpw/s+siiF75M4OuN93pihS6+LTWFGN0QgOqiA/L68hHwuwjTnrNs1cgf8SFpgVDqwWFDzuooMAioiHFsZ40MGdpFcuDmk/NrEhUwCZ4NMH5+2QInrfjH5qkLQc7bYi9l1
 GnhECXcr
 /woUNDl0L466mqap+Sk6On/8u9s+x5uwq1pGZENbujvXhv4lpm5UX7l6t7LrQPSELsLwbbitfSVHpojToYBoL6p3smfna/pXX7Vnm4w1AAwEIaeV1RaB3/q8cSAhoxrZHn/csgTIFCgVNeCv1aRucOTZomCLMthXvyXMEISKFo4m7i70GGflH7C0CiCs7wLbcOiQ7ng0hAg+XDr49lgULD94mvwJMRIrkwVzc4tGaDBPFeSK1iayJBkuQ5fVAv/+sMbBcSCOB8j2LoY11Hz56IH6+tS0uZlNf9v0U9OmzSJSCbJ+MQrElkBliPbLtiOU+06XfyyPwZMOg2uuActU+L6AdFkxhUAsGLW4jHRfg5YExthocE5lglIaauL0Hu7G15RoLrmpEptyDAKPaQWllgzWkjQ8kjREiPmh+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 05:50:47PM -0700, Ackerley Tng wrote:
> + e.g. for tmpfs,
>     + Use mount page size.
>     + Respect mount size limits.
>     + Use guest_memfd mpol and fall back to mount mpol.
>         + Gregory, now you can set mpol upfront on a mount! [3])

I haven't had time to quite give this the read it deserves yet (have
been traveling this past week), but I think this mpol/mount issue can
be solved with a new dax driver (which maybe provides this provider
interface) without needing to involve numa policy at all.

Essentially

fd = open("/dev/cxl_dev", ...); /* backed by anondax driver */

then later when a fault on that fd happens, the driver provides an
anon-memory allocation that explicitly requests the node associated
with that device - as opposed to trying to jam this into mempolicy.

If you're planning to be at LPC, happy to discuss this in person, but I
think this provider pattern is likely much cleaner without mempolicy at
all if you can just make the provider do that allocation path for you.

~Gregory

