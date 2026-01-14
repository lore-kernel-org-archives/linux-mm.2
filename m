Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1FAD38FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F296B0089; Wed, 14 Jan 2026 12:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36936B008A; Wed, 14 Jan 2026 12:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42E66B0093; Wed, 14 Jan 2026 12:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F9F6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:28:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60F7813B4CF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:28:37 +0000 (UTC)
X-FDA: 84331253874.15.1AB5F86
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9707C40008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:28:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pvLXrs8Z;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768411715; a=rsa-sha256;
	cv=none;
	b=g2Qe5PsZzzqsypJDxOoSGz6HyTRHLT/U3QKQVO8pyFK+j4FfDCk6Y+GPRgFwwiYV5kT2lL
	GJARjZbcu1y3q7bxTyX4o8yU11LtX3tJh2UVccAgetRBK/Gfr/ej+1Y4xs+JiB4a/ykoPa
	65WFPe3j2w92HyX9c4oXAtLPWyTlm/Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pvLXrs8Z;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8gk61w9S/yjYbnW7IJJtdpbyzDzV71vvh8bvL1b1DI=;
	b=am/7I+DhZAHwZSXJXe1x6wD9ZWZp/sIbEPZej6dNWWPpO/ZieC0y1GWuuPNV2EsC8PIflj
	aMRC55sA51HZiEf3SgoQ+knCUDOkV6RtPLgaZSJvxCFMr+85pG1N8iH8T2KuP42hWOd/MA
	DNIqLTsVeDLB5Vh4deGfACu3dCS1un8=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b2ea2b9631so4987785a.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768411715; x=1769016515; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M8gk61w9S/yjYbnW7IJJtdpbyzDzV71vvh8bvL1b1DI=;
        b=pvLXrs8ZaZ7kL8KXeeZcJ4m8fA0tdLrYoAe0QEc16AyISM7Z+PHoyHKG2oQDwLoMfU
         7cql2KlfofSOOmMlrYD9IXw8rJL8KX4Ya3JOUCqc5ctfNtMQoSU7h5z15r1cRKxdsc4/
         i2oeQXn1N90IePbODgcUL9gw5uoKTMyv8Vz0pdAZrHwl9hsXtuSGzkbNX1Jxfo849/34
         1OrM5Ze30LfrqjxWJhOu5FcN/k8R5VI3dOneHs6gvsXlXvBB0fwCQeu3FWEzkP0vIwSW
         jMhQ19+z93m/ge+RckzgQ3kd1gyLPgUG54xbvS9vyw69HV2ImZ3ah6oHrq7g8nXEy8e0
         O54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411715; x=1769016515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8gk61w9S/yjYbnW7IJJtdpbyzDzV71vvh8bvL1b1DI=;
        b=cBwQiKHuFJAK5Q8Cl3rdS4z2ZWJE834gNzYD6VM6meJXsiTJ+kf9ii5CQHQGD7TSza
         ypetXyJp5Qax5o/xYkpQd3KGx9/IVZlSpQYT5mXytSNz0+yo/KAbggbem7rq/6QeIYXy
         1Zx2eOzXDgGsPL05Tw3zia1nBV8UIXVoHqyPYmaDEz4NAvu4X9vGlkQP1c4pbLGYy0I5
         Rq1PDPvNIy0HFEA9xqWzAKjp78Hc+oxRKX4B11ZaFBbYwJR8yBUSKwUfcjdZHgP8D/C6
         vwXkT3sWeIdd6I0OgrSfhm+BU+mJMvEn5+HwnYdEiwQr+nMG8Dz+LEAT/Nw1yBD5OnQX
         MMmw==
X-Gm-Message-State: AOJu0Yx8lhJGLgKjBGeKAc6DSj5OBw4CAHR3I32hRMtKQ2ubNumhpI2N
	ugDydoUmXW1pZVoizAk+iZPsmXuIcI4oxYzOBRRRd9PCkmhIidZljBcAY6xd8BXyXVc=
X-Gm-Gg: AY/fxX4ryCr4JX9sd9FuiktDOaf8TUr8iGjI/QMzKNlnEgXUlfpFehjp5riSLf3arfK
	MDSXivEBRdtbPHEzhUzjAHgTG2FDIFLQXCXmcEncYK5/JNUpcaLET6sJcSOg16YnNcaen74kMLE
	qEYy7PvpHigcdRmhO2ghJZ+z4y7/nkfbKndYKNP4UFGY8JB1qgRE197jpgkHdmQNpRlUupQZ6PT
	aKXspmfb4yFjkr41tkM1SDnboOEe9KvjSRqzPVIMjMk1lEp79MrVk33XFHpkw84yEfGoIJCrgvN
	p47rfA9riEti3UmUqqQ17w9i9FecXy7NbkZzeh1RyowDjVqlBSuH+JfF2mNr1s+3sQFtf09t9Sl
	vT6r78ofe2fVOOWXlg9gIm2SNGX6wWb/TNfpdaUqEE1wgcOiV6S7VcLAE4akOJT7xGOy3YJlVzL
	DDP7Y5K8JxhVf+/ap1pt2USLoOkeQPXjzQGxiMzw98Kv4y6FRGZE7XAFfb03NmW6zgqbs3+Q==
X-Received: by 2002:a05:6214:f6c:b0:87d:e2b:cdf7 with SMTP id 6a1803df08f44-8927445388dmr42459046d6.66.1768411714702;
        Wed, 14 Jan 2026 09:28:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8927a07c731sm10671566d6.34.2026.01.14.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:28:34 -0800 (PST)
Date: Wed, 14 Jan 2026 12:28:01 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] mm/memory_hotplug: return online type from
 add_memory_driver_managed()
Message-ID: <aWfSIX5lRqb35yUf@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-5-gourry@gourry.net>
 <6a9db6ff-2fe8-4be6-baba-7db7913898f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9db6ff-2fe8-4be6-baba-7db7913898f2@kernel.org>
X-Rspamd-Queue-Id: 9707C40008
X-Rspamd-Server: rspam06
X-Stat-Signature: xk3h33ni6k5de1ni49oqyduup4hwzgjb
X-Rspam-User: 
X-HE-Tag: 1768411715-944262
X-HE-Meta: U2FsdGVkX1/nTZcvE4IFL5Hzc+CxJT+exdY6rlMtQB+0MMxS4WSu2HyDGGlqb7U7wr5ZaAbAtMnlwdjMHPwlQq/8jVKTFTZ+jZW/jcuF1jOcGXf67D1pyWeRjgaNt1MLVuHetjLPukzPfvWQ48VuFI5BTAQtgVhD8NPce8pkp1Tk92t8Pfjaei93N1/X7l8n4I6sawDGaqN0xa2BYGoZ6mUhb779714RTnzvjjZ1GD325vlAlm2qpLJVoDB3ivCGXSGeVoMCSSFOBIBl42+G/ZNwWi0hCwKkdJOGuD8FvQRU9mTZOpj97rGqfVzA7Kp1V4Kist5rLsabT6B9SFQQ4AFkijjpTHI5OXNzQ8/ztUF+p1CmgZUVNMhjcgEdRV1VPNr6exN2cju3Iss9DLyd8k7Iy7zvgeQdzlTHZdI4f66HYLhCauJbJFiynik8iPlL8ZoRp+D540up6u1tf7SaVHx5yFOmUnOQpC1LAAltWcAt2S5282mgVS/Y1s2CqYkI9McSeuUSmhXZ5N12U+JC7cMcLxz/uuc90pD2ctbZYbswnWK62LjUJ/ZwbXarx4TxDZuo7V1YTIBysDoaWxoTv1IutkwQdBQJpB2L1V+F1Nm0F8qPzdvoIBHgctHdiFFnlRF1pZOnJgaD08DB2K8Noi7to0OtjBp4e57DObdiz/tF5O9lZyXKkBR893HJjcCkUKX6vgzYx8MsFd5XELmaiqS5nXQNiXc5KjG/1JWtsLJ0vCdQE2luhyKliaPdHxUklal0Ffwv82jbnhyg0QMo0QurKWXEmow/cpMPFACrV6zsZ4yQNuG8kl8AlfqLn7kEeAf5FbX8XpFXO/AYE44xD8GlMORbFgz5hdvdhAgULavz8O4NrFSEueJHJLrL/EReXBSKZ7UcvsQSVWXf4DAqG9jZfX00VRZjzzzsMbPg2v6JJT06JrE3eO9Ohq27WHCyo2TkCL/AXVcT3rtnb34
 LvnRlNGi
 mlvgl4sIM0EXOcdIEGl2Z4/EvZsI00LBdbakO+ul5w3WX7+uCz6qBuQQYQbOBTz8svEOn6wiXjgAm/Cy2Po0tSYlkBFD7YEdS+x7lMBD8S2lwYD2cGO8/LjMjmMNAQcq717/HJuZ9Zs176hjgbzvcziTihgkDsSk5OBWycEXi4dO5ORXRe7b/vCkuOc2luWAnVqBMGcsyp8BgzjjI0HMguW3YAt1aLThHocrJvbsNuTrTnABVWyVumYxBmsWRBWZPSpTkcBROtEtn5KUMHdb8FM/z81fbGgJN7S9kQCXdZsmPLkNe+c3gvKjtZTn1o2NRsgGhPxRSwjAB1gHQSMg24+oMcgdyLGd54G0E7dKQxsilRX92CNsOtNBqP3J3dBnMTV9I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:49:19AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > Change add_memory_driver_managed() to return the online type (MMOP_*)
> > on success instead of 0. This allows callers to determine the actual
> > online state of the memory after addition, which is important when
> > MMOP_SYSTEM_DEFAULT is used and the actual online type depends on the
> > system default policy.
> 
> Another reason to just let the caller handle MMOP_SYSTEM_DEFAULT itself by
> calling mhp_get_default_online_type() :)
>

Yeah i don't even end up using it, this is just cruft from early
iterations.  I'll clean it up.

~Gregory

