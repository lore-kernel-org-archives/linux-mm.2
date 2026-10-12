Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC32CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BA56B009E; Mon, 12 Oct 2026 10:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233DB6B009F; Mon, 12 Oct 2026 10:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148EB6B00A0; Mon, 12 Oct 2026 10:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E02636B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:11:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77CB2A0DEB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:25 +0000 (UTC)
X-FDA: 85314161730.06.D2B100C
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 792CE180003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqW8+6FO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2I843zxPr9lME1nSEmz+NsS/OxECT+sAh7A1cwprg8=;
	b=B4OKBcY8gd/CvQWqp9WGVY0PAa3ONcN+YpSaWMtlBaukQdiVYOeU9N7X3vS/DvOgRxvLgh
	bR63jGZZqh4In0ze2WgPfYG4u/63z1xDFdtFoGcJ2egox+N+pn2je4E9cyJx0Kd2g/GTKx
	8aHNBbh1cXC1hL9/+JLo40L2h3bl2Lc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqW8+6FO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791814283;
	b=FA8sNSQTEK2WT99AGYNRaAIkWIAU6x4sBfw9e1Vcn99GU/c62XzJ6gFCo9howByzDajL9x
	kcn0shZJ9y7NJXqvxSjjkql7Ed02erEtQxST88dHgFzrgdUap4HCywMFeElCwcvV/s1tHi
	YViN7T50aHZJg7PzmUmPQzEfXAjoWTE=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91986c5cb75so26065906d6.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814282; cv=none;
        d=google.com; s=arc-20260327;
        b=o67LeMbT5kfgmMyCHUH849dyXUY2VLdJFGvquUECALWX0T57Vjxta6eoLh2VR8diQg
         lQFE6Ij2mooDbG0sHVG0m6jktYVwQabfQHDJGrOmNS0dJfC/hgQp+Q34kvqhpHrPJ33g
         EYcNXQZpC3J+WUc0hz406HcLRTFyMp84nHPd+oPOtHWXFkG7MzIaQJtIs2OWrtpCSNfm
         U7YpjIzUPt8gy0PAcJO9Jrvoqw1mdWYBxbpU7kwyaowdNcofkzUTIoeUH3CEOo+myPBB
         VXs7NL0G6Y0VkWw1kOvMcnR1pCZzKef4tAJ/MHOBKjSOKDFmJDFS8Ey6SOBpaqJod87w
         JTNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=K2I843zxPr9lME1nSEmz+NsS/OxECT+sAh7A1cwprg8=;
        fh=Gep+1jWKg70MEFhv/7Vh4qswi8BH92lV2QGIVgy8nLg=;
        b=jbLDh8b/A3XKi8UvLJneUNOiSVT6DeGApOXbEgDRaICWcmDDxuWjuS9I6DsUMtNA2+
         m6zxUBvBYxcdF5XMQmwoBMEW81P8tnXn/pp7f9Y48AsWjBMDOy+BHQvZOp3uVNVei9po
         o5+ifQk6nvJCeVru2eqYW6PHkL3b66zNYQvrc/17uHuDknXs5ZNmi5PK0yyfreL+96fC
         Ht5kHZD2L6rw01sCsWlOB20negtgUVUAF47OoKMmNPKhvygbYKN5QPnL7vgAvPfU1C6q
         RfMikDm9WCVrhIDVDjN33J9tWpJBX5gdyAKgkt7usQFIBxBkKj6tl4s2umofkK/le7R0
         1JqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791814282; x=1792419082; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K2I843zxPr9lME1nSEmz+NsS/OxECT+sAh7A1cwprg8=;
        b=BqW8+6FObkK2KbVCEREVEoGtXGaqbO6CdkxnAySK3CxRNX6nm771ujEediX3Wf6Csb
         JKfmyxb5nqpNSbxJReZocdjACWLnM4c66gvGnrIGPZS9ZJaSafEQKtSz7xO5UXsyv0v2
         zs2J3r4C04lJWHozScyHT/QudfiWL8iUwRGEhvdnaF5FM89aplZwPRpQbRzXQap7bgFu
         ytqyP71RypIc9jhTMQm2k47FOWnvRGNZBfXLNP8U4T3Yh+VgS1BzomHKYGvRO7jsJbRp
         qs5p+y8UW6DHvPUN/gRBOQtR9rM9e2WMr11G12ZHw/n3rtfMwMAf4vtwzm6kBYpaK9G1
         u4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814282; x=1792419082;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K2I843zxPr9lME1nSEmz+NsS/OxECT+sAh7A1cwprg8=;
        b=C4lvXqVRys1KIIvcQHJxGpu7fe7Rfkt396Y/LePN9J42rsYj0sbAYQer/Jv1zlsrvf
         tsDR8cmFq0uVriOvuyJRqfFgA7YlLyUj9g/NCwJg+Tp/JUiLD1cvhqSbrWTIZwKlApHt
         VDpO9RHq12jNwyTTpf+WjRWhYoRd3sOy9CTw75TPPLAKCKapp8X5HelXylNvd6PEcFoP
         lVe/JBhHpS/aju6zjP/E/3qocaQhqeudbqwYxEkevkyDs4W7cN86TeVHqlg08vE9NGAr
         riguIrwRsrvKmvbMHVABzVtLG6Mm5dEzZRyB8NwZUeP79IU0mu17RpnnLUzy3oJyRgVM
         2xng==
X-Forwarded-Encrypted: i=1; AKwUvBw3tODNKgUBB018YvrWJwwULjIFQA8++b3R5NpuAAoP5Slu0ZhFDpywCfebR8Uo9fEQ09XG/MBwNw==@kvack.org
X-Gm-Message-State: AFq9FYJ3s93S+knrBuA6RNl2kfTVG6dpJhO5tYUod0RmytuGyIno4NXp
	2VmkHTYZh2GP32zwPstOQyey0ZEbwi7XGjZupyhd0c+QS65o9nNpkkGc8WgXzWnu3mrm3tZr7E/
	BKwZRRGbQdw+4bqzHWhXIC1Jnh039QhuRbrwenm76
X-Gm-Gg: AYBFou2cYwPOSDh2fyRzzVgYbOSEHSrZZ9pmPPIr3/WdJ1qCpsyYFj6IsYxvQSidgFE
	BQIo4/YK3dfUcG9KpJNFOKkIc+fTFdUoFMDz0f1YM2jys6KwWWAkGQIV77RTohhFd3Uv2q5xDMw
	mFPsz9NTO9Y8ladrN0CcFBiQFoGff7nxiQTPX9e2zIjTHriBKAPidlrmdG69bt9f/XR2p1/uvqR
	4Tdq0nBC+PdEvb3On3GEO+8mNCSoech0vo5EBHaLCOGdPZHeDSH55C60ctPEwMG/4zcUWOezEq0
	sIKh4DjzUSitWiL9PbJitdqmcJeGq23XN0/Omx3+4TODWTrDYpD2rUuZFbPk1mT+BNQd53ksPPI
	UMYAHPoAIAeY9tnS3iOWe
X-Received: by 2002:a05:6214:23ca:b0:91b:8e83:e4b0 with SMTP id
 6a1803df08f44-91b8e83f3b3mr19792736d6.20.1791814281518; Mon, 12 Oct 2026
 07:11:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:11:20 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 12 Oct 2026 07:11:20 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ar5iaaLcyz9dCXQI@gourry-fedora-PF4VCD3F>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com> <ar5iaaLcyz9dCXQI@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 07:11:20 -0700
X-Gm-Features: AclHuK-GAlH1JSAYNCIS06aJZxJfvunIjbH1E5FXsRqa5lYNWWJsyEqAXZVZwzo
Message-ID: <CAEvNRgFO5FUFwU2GEEbHogLmT+SXVu1asLe5uzvRte2jqXthUg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/17] Allow guest_memfd to be created using a
 resource (pool) fd
To: Gregory Price <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, vannapurve@google.com, erdemaktas@google.com, 
	jxgao@google.com, rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
	David Woodhouse <dwmw2@infradead.org>, yan.y.zhao@intel.com, michael.roth@amd.com, 
	suzuki.poulose@arm.com, Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com, 
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>, kernel-team@android.com, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 792CE180003
X-Rspam-User: 
X-Stat-Signature: ib58sa7ug1hu3atcbfm5hghm3gost16m
X-HE-Tag: 1791814283-21392
X-HE-Meta: U2FsdGVkX198t7Bo+i982892/+dXE1V5blu9t0XSZUDf/cibaBYW0N6N02zT1+qBDI3ygtQzej4QHibM9uggss6EPDmEZDQdyh5n4bsKZEgDOCNPSKcYeMiruhfc3makuo9SARMR51HgYSh/GPYJ2+yFpWoSk4ebDjYZ/XL/qw2Opap4K5JcfPjPm768Ibl53wUj3opeDLxqjq0045rY8f3WYBw4AGnwVh7HucoAGbCZeEtKNwo65PsH0/NyD1zQFpg3rtE1DtEW5lo6srZM0ZjVCEiWTQcBhUlTIWEtIMozm/bdxgqNtYO9mudwwkaQk8q593DRWG1o2ynrCqCnQf+qp9wgmypIuWPW8CEOcTlvs9k0aAlHlIyuUcolc9O0G032zBg3E9f+0P1ks43QDJkyFumuU3ek6xR6GYtxequROsGO8FzkjnM6NoQC+R/Q6yBoisuxJLB8Un/mCRtNpULyPPASxfllVkGGqMmM2hK/rpKqSmk8zqDe8rRgobAu5ALvSN+ElA89jkW/X2mb1LWafccN4N4pJhPhp0jVIOWOGrUpu6qPbxFl9jxo0iBT/lNoE8O5MY95xBijn6DbxZgOomCXPY/lLqPlNWVVN1vDF9NAD6OWEa92XAIBgYd3P3OcB6QddU+fKZuh6A8M2eQbaH5HUkYMTSbW58ZvaOrD+/hTWDKAcIKRL7CFYP3OVZWlmIqsglVS7EbHhodxtJy+b+mKAonrlPpwA9VXZqizsJRsJMTPQjS6Z8DZvNzObdWPnPZz+ZySj+lLKX9ub8cerzirE63Tf8ypvAp0lxPklm369NNFXUtjymX6+EmNgBptiIbxCvIPzZaR36u4hptkIVS2TLleKS2osH7jYDeEF9ZqxHCw+uABbVcSKMewTzZb2b74BEHYrZU2yL5AfqyWquz0I01oSDXsDATvJG/89qpkukZ9gmcmy1WMLPvvmfKEiB0SZB1gp1LrU2D
 6BCHpoen
 rqS82oEoZ+ImmBzEXPmxWB1Q1RHaGDXXYBvClHJKtF+Xm++jXKwapa+ZkILuqMCFeLAikRFnV/nmWNXuIKT1Hhhm6VKE7KxgKuBWmF7+OVpmU1IrAPwppKrZ18vmWhW4V4MBySi6HjH3y3KsHV8Cd+RtZLu8qNapTATLI9emeamhfHSWPiv+mbpH9+Bc9XQxI4YIHArxvP+dgJ6fhO38WTI8kiV/XyHZ3OoBmQR3e3AbB/M3sq2KyHn2uIRnem1LJad9rffWKKPYy1nILBc9nrieE+E6nXsYcTPt+hOfsLYH7BluMWGi4BOP/mLSI00qV8y21yULIL5maMJ4XRqCGeXtcdC+Wvj7YqsTVb8OFVLM8m/9TSDZY43M1LzXbUoaWm9wVoiHlBsiwQB4OvKDYNLCEfipe9XrGWvVkWx6w+ASsgQFddl6Gs1AfTyFRXzn38qJn1G9ldPzyy0txGnyeC0BTlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Fri, Sep 25, 2026 at 05:50:47PM -0700, Ackerley Tng wrote:
>> + e.g. for tmpfs,
>>     + Use mount page size.
>>     + Respect mount size limits.
>>     + Use guest_memfd mpol and fall back to mount mpol.
>>         + Gregory, now you can set mpol upfront on a mount! [3])
>
> I haven't had time to quite give this the read it deserves yet (have
> been traveling this past week), but I think this mpol/mount issue can
> be solved with a new dax driver (which maybe provides this provider
> interface) without needing to involve numa policy at all.
>
> Essentially
>
> fd = open("/dev/cxl_dev", ...); /* backed by anondax driver */
>
> then later when a fault on that fd happens, the driver provides an
> anon-memory allocation that explicitly requests the node associated
> with that device - as opposed to trying to jam this into mempolicy.
>
> If you're planning to be at LPC, happy to discuss this in person, but I
> think this provider pattern is likely much cleaner without mempolicy at
> all if you can just make the provider do that allocation path for you.
>

Nice meeting you at LPC :)

I agree with you, I don't mean to require some kind of mempolicy setup
for every provider.

IIUC you're saying the entire /dev/cxl_dev is some fixed NUMA node, any
allocations from /dev/cxl_dev is from that NUMA node?

In that case, if /dev/cxl_dev is used with guest_memfd, guest_memfd's
configured mpol, as in kvm_gmem_set_policy [1], just can't apply
then. /dev/cxl_dev fully controls where the memory is allocated.

On traditional mounts like HugeTLBfs or tmpfs mounts where the mount
config supports mpol definitions, we first apply guest_memfd's
configured mpol, and fallback to the mount's policy if there was no
configured mpol for guest_memfd.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/virt/kvm/guest_memfd.c#n400

> ~Gregory

