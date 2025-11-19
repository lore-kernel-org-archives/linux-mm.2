Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01A4CF394B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4386B000A; Wed, 19 Nov 2025 11:33:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C526B0028; Wed, 19 Nov 2025 11:33:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8C26B00C1; Wed, 19 Nov 2025 11:33:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0886B6B000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:33:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD17C1A05B4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:33:23 +0000 (UTC)
X-FDA: 84127901886.30.12ECCCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 149CFC000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:33:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DVDFHrJk;
	spf=pass (imf10.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELdM+r+IjqfOBK0TgIKHMPjL9L+UqvoSh1tlIc8LMCM=;
	b=SZMMcrUSbIyTvaM91rqZlz5TP9bo5QT18NUQnfGCGRk4aIrGHSif211U/vSf/QIH+3TrAy
	OK6ZxT/J0VM9jP6Gbwy+BnZJn1/IO4TmE9DLRJAeyWiS5fKNGm6z91J0yfJ8nXfBJBINsF
	cgyXDOHiVNbUaSzkjxaZzWTJpWTSBSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763570002; a=rsa-sha256;
	cv=none;
	b=ZX3degk7G8iHBETTuFAyc4bdvXJLc5eJ8Xiq+A4Pza+yf3CsIamwvhkVor3YvtBWnYOL39
	W2xmHyMBY7YbJ1cVSE6RdRUbaZFZ6XQ0hdfzUSD8d7AkoIM7mBjEB2S6p4jqwmDueRMXxj
	m28fVwO5V3AEuiBkHumu8DavyqFuUDw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DVDFHrJk;
	spf=pass (imf10.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87C9C60171;
	Wed, 19 Nov 2025 16:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFF2C4CEF5;
	Wed, 19 Nov 2025 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763570001;
	bh=i7tu3yLM0VynVlcY5bqcs6DeJo41e1PUYhoSNib7lwk=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject:From;
	b=DVDFHrJk84A4zymiV57X3ExnwuLvW0CE/LGPojju+eu4wWuy7NJcmGzR0WD7DMXPC
	 AR7po6HBkGfMn+DMQZAO/WfAqULzdm848KNna+EoU8nTyUHFyvcKIzqdQ4v+KaQkYN
	 8MmjEa1NIFK0dl+BkmW0tETpK18AwFc28h6WQCq9E0W/TN8S3eKWprf7yCc749NBi3
	 cjKnqViCC70PjVKaMtt1MqZwAOk0USTkCrD8nNBf4qpIKnbJqc+R8gpd9sbtvoZh7g
	 BEC18R6G+GcBu2mVDYrReRdyKMAuKyeiDrTf1nnUuAxDd0ju9L+s+dkjzexN8nR1zb
	 wxU1oQwlYLUkA==
Date: Wed, 19 Nov 2025 10:33:19 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linux-doc@vger.kernel.org, rdunlap@infradead.org, 
 tudor.ambarus@linaro.org, linux-kernel@vger.kernel.org, pmladek@suse.com, 
 linux-arm-kernel@lists.infradead.org, mukesh.ojha@oss.qualcomm.com, 
 linux-hardening@vger.kernel.org, devicetree@vger.kernel.org, 
 mhocko@suse.com, rostedt@goodmis.org, tony.luck@intel.com, david@redhat.com, 
 linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-mm@kvack.org, kees@kernel.org, corbet@lwn.net, andersson@kernel.org, 
 linux-arch@vger.kernel.org, jonechou@google.com, tglx@linutronix.de
To: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <20251119154427.1033475-26-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-26-eugen.hristev@linaro.org>
Message-Id: <176356999980.2657652.14038918040469312144.robh@kernel.org>
Subject: Re: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 149CFC000F
X-Stat-Signature: wf86qk8t5p64c7om4pxxi6n3saab8esh
X-Rspam-User: 
X-HE-Tag: 1763570001-839387
X-HE-Meta: U2FsdGVkX19gHBoAYakXy6ZSLh4o82T7648lb1oUol/bDbRZ40tS6nJcDFtfMpR0vj02abFrIrp8VUIxg4ejea7bzbvt6+ZLYWo+8tBRyJ643zA19hRCL5K/OFuUYnvNdmnCWB/Rs5h6d/7pRWJRTpSCiQ/X4YsptHcny8Rh8z0iO3knvLyklGWbnU30a/bY5fQqb/7NUo7FqjSWI3oCyfIxkrwBJ3bBjZ5hzsG8TPWac35TIJjTqDxIBB6nAXBJEXiihjOl9lPlKFiiRKgLhJ3KzMMycLgDHl2L8aiATPCcgwrob3VnNSkDVaw8XdRr16butjUDpGeqohSYVwholCeh5Zx7MzGm0p4ik89Imp8t/M6p5rNMxFQr7vwU6S5nTr+Qi8v1ms0xy5MXR8AcsJBhI5fK+jEbXj0Rp1zP53EAnzfm76ZK7PqmD486t5FFJmocgubsftmadwXzJN7kDcw9vmekk2iKOVzfC0VvLd+TPgp+rIdnHDZo0OW/dXtlxpH9Q7fEVtNZqvsBj+DpRr+6JdehDuLGnzgIB8Pzlpd59vhBCHK0AneYJiNvevtkNuVyo8EWm3+KHvaO/Si8ri9BZEuWOnE1aCFJ8HmlAhB+ezYeLmaCqLitYrzecj0nrl7zVnu5G4GsFZLEsbxSx7m/1KHK7tX+H7TvnKHzaAch8jxDuudR7sIbR7J4x64eXiVCH8TBhUzuFaxcdOU9jcbM4s46dquEPppJfcYDNi7u8kpqENYoWv7JEz83d47z5hZcQec0uKK/0rthxWpHKxvP9lnmzPwbN4ZQY1yhakILHqvC12xpkxuxM5z2TXKl09q1FqURMdj1mJUcXoOKZrxIxPie1p2sAsCrNw514H7tlLgW/30sHkmwjyklR9EffN8VCOBqt/aXQoQkYw8S5IZnhp8ZBEpfL8JilqlbW4ZUXQvX/zhe8U834s9CTrK1S75OEWENNV+AMUH3VBP
 EXPqsJLG
 uyQVmyRwrtZ/yCavZLa3xDzHod7rZHP6RDO5p1bHPuo+8OOtR4UNilHrihXmY4yhwTgZENzMq0qTYdOIKOmNZXuX4kTIxWxhjO7hHeBqrsWllb8sOdCUCOOOiEstgBcMyZbnz7sXCjgNGhUAOQJguey2fubnGzanbXmA1wKT+SnDf4tql8DgH31EgjTZUZ9qUPIJSZBtLgxE6vUYz5jLAxBn0wpGQfj+dLvzlXCKFLcVmDaDKzpSHEdOF2G0Tcya4Hon9x92HahaRW/WH3O1o5eZRGQHyj6D8Jy+d/XMz0ayge1aegHyYa2rMgonvrxKdlFGBcmuq2ha8rFpgjcrScT4f8OCcno11k6tiX29x1Qqnk4SQ+9cvmM2BNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 19 Nov 2025 17:44:26 +0200, Eugen Hristev wrote:
> Add documentation for Google Kinfo Pixel reserved memory area.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  .../reserved-memory/google,kinfo.yaml         | 49 +++++++++++++++++++
>  MAINTAINERS                                   |  5 ++
>  2 files changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Documentation/devicetree/bindings/reserved-memory/google,kinfo.example.dtb: /example-0/debug-kinfo: failed to match any schema with compatible: ['google,debug-kinfo']

doc reference errors (make refcheckdocs):
Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/misc/google,kinfo.yaml
MAINTAINERS: Documentation/devicetree/bindings/misc/google,kinfo.yaml

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20251119154427.1033475-26-eugen.hristev@linaro.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


