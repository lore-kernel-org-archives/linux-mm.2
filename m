Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57000CCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 20:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD848E0121; Fri, 31 Oct 2025 16:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DA58E0068; Fri, 31 Oct 2025 16:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB1E8E0121; Fri, 31 Oct 2025 16:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 896978E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:09:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26A3149A3E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:09:13 +0000 (UTC)
X-FDA: 84059498586.10.A480667
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 15EA4180006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:09:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XYNFPc9w;
	spf=pass (imf06.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761941351; a=rsa-sha256;
	cv=none;
	b=EonZlxGb6U9EiPbgQTVlIllXwASIOHm11Lemhwtxnb3TMesa31gnkyT8Gm73Gk2I3WTZgq
	zMJsP0dfHvshiBoJYeFxXvBSA4Oa8joPZvcg4Q32zBEd+T33tWvlkczogS44QqrQxDH+9O
	OaYM/Va18hUZ3E3T09T/Cn3KXNprH7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XYNFPc9w;
	spf=pass (imf06.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761941351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+JhuDAATDqDv0kZKFz6PoTp+tnieCHsDbU+05x0RJ0=;
	b=mrtPsMUxoHvRkcdpa5HVbTI33/Dqfy3AV53Ra/Yy2YBII0rPtv6VnaLceXmm04T6X7rToA
	UXqf7tKe0f2eQZXlCdr22f5NyBsWJLPMVlfiwoG5R1bhKGF8K2SyRUUqgOav8IktNiEgtt
	S5kcQMHLFrJS/YQxp+lcOrhfrx+aMj0=
Content-Type: multipart/alternative;
 boundary="------------YM5OpauLXSzYUIAt6Id6R7VP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761941349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JhuDAATDqDv0kZKFz6PoTp+tnieCHsDbU+05x0RJ0=;
	b=XYNFPc9wQLawYvWpraL7z+jj6q2A92keaWeDTGtGcJAEnwX9UlUMU5dQLBqjh4lxOT65FU
	PeXZYqhS/2T1V4GMJoacnjESn/7Vx9W0LyQKaS4d6hEAvZaAek2iFTAdS4VHcZpJyl9Pxa
	Fc3+5xkDNAfKlRXoYuixgvtKmpWmVoY=
Message-ID: <16b37574-32b4-40ff-a8b7-2b443f293d74@linux.dev>
Date: Fri, 31 Oct 2025 13:09:04 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer
 printing
To: Simon Horman <horms@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
 rppt@kernel.org, changyuanl@google.com, akpm@linux-foundation.org,
 bhe@redhat.com
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
 <aPdVSyLRKeRN3i6z@horms.kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <aPdVSyLRKeRN3i6z@horms.kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: y8mki3tnb8yidgug3dojiky6z94gqwgi
X-Rspamd-Queue-Id: 15EA4180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761941350-145299
X-HE-Meta: U2FsdGVkX1+eH3EDjynBSCaGdsPEuhm3hvsW+aQ/oqv8aro6tMtTU0GDGYH67hz/9lgYXPfqqtWbVLUNQ5gme7J1SUirCF6Enf69iHQjJjO3owIfUuwyeiPFotDlMPYwqRvt3M5QK5q1glZcB3QoUjXg1ZysPCUnF2KO8jvwRZZ9k+iNC8hjI1gcEiQA3VfSwtfsrK0TMHFyxyCJ8q0WbMBGnqwusA46zH7t/uqODwNTV+7L9awv54XbswHd4x2MCuPuFJqBCAnRuEDUdtBW8tkX0izfHihrBS2FuJTvghfyw/a7ADzNY5KAaSMzjkmJ0ICHZb+JQwuJauoe9RY/b09C9KL7hYUtiKvj/i44oXwtrav/DXNLEQ9jiuCp8iSo6l+HWw+9EMI4Yh2V/EOKzy8M3DMDdePXVHtzXeDceKh1mEAdc/pNPn5Nw307ARjsWq8K5sel2cEe27JqrpTQjA1lroKJ+RynFKw/EgEAI3DBjQkKt4Q8uQ1GjOzHkuHT6t0G1VhP6nRn5zOlxoyUlB+Y8hcDScOMEQBbAHpIymv7pTGzLyO0HIiOlnHfBYtM7QI+IaC0ljIXg/nUPHNuJWmziqZYqvbVK/q4hIaHr4WXevTEnA1U/FAjT/Ctjn/RB3Zg9RSHDOIpO8LxLNlXvZXPgT8otBZTwn8OcH50RP35dE/7wv4Nxll/2j8PKlDNwPfXNewYWXBBuTRzkvbVycvQiAkhzN3mJ7tAQzSuP3P15y6E1vKisKONF/Uu8C88SG1GxXtyxLUlYuhXVcMB5VJpEtgXDhbe3u+6tdTWkv2Ext11hBu7YysgslfIAkJAb7bRuBNJ1tyy2/IQo2jHJpy3+KK0VkEc/6lbtSz2LycKP1AlTRmdYr8iYHql1Fq54ipwlDCZjsMA7cbQ7B4U4mAyW2JMD0E6m2YPWTxud1+x1j3Upn/nIrziDnETfZV25fDA3JPvmoKx5dvoYYx
 Bk+T8Nlc
 14PQ89+bioYmXM9APXsnDeAhxIHTuwfnRM1C0v6K8WwGhv/UR+MyBwNsURwHoTy8fpEj2mJlGIx4i61H3A8cugQSulkiWGi+oKrVJmI7rZMwt8WY1bs6ch2vt2+7t/4CtcdqURAFF7g9NL9xy72BUNT3v/M4Y1M1mM8cgcUOBj+cFfsdXlpHyuqxPzt3hZNlGJMUcvwBQjb+JkQRvB/ehkM8g64J38DfaLmArBLAQArT2PO1CXe5EaK2LgDsImvcWDZbQxQ1vdDVBtuahoUQO4/j7fn5VzK8SgyNY8+CS5murL/pAKF1QZzISRZOjgEmG40sEnTND61kawNGv5GIRw83TFPsxVgZSBwiZ8dO+s4iyll219IXiOD3Y96Oq4oWuXmu1U5U5QmfG5psg9lUjRxfzqx0IwZhxUTe++FjUdc+1CO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------YM5OpauLXSzYUIAt6Id6R7VP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, Pasha

I noticed that you are moving |kexec_handover.c| from the |kernel/| 
directory to |kernel/liveupdate/|.

Several developers suggested that I resend my patch after your patch 
series is merged upstream.
Therefore, I’d like to ask if you could include my patch in your series. 
This would help avoid extra work on my side to resend the commit later.

Thanks,

Yanjun.Zhu

On 10/21/25 2:41 AM, Simon Horman wrote:
> On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
>> Make pr_xxx() call to use the %pe format specifier instead of %d.
>> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
>> -EINVAL) when given an error pointer created with ERR_PTR(err).
>>
>> This change enhances the clarity and diagnostic value of the error
>> message by showing a descriptive error name rather than a numeric
>> error code.
>>
>> Signed-off-by: Zhu Yanjun<yanjun.zhu@linux.dev>
> Thanks,
>
> This looks good to me, even though I note that this file
> has moved in linux-next.
>
> Reviewed-by: Simon Horman<horms@kernel.org>
--------------YM5OpauLXSzYUIAt6Id6R7VP
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi, Pasha</p>
    <p data-start="180" data-end="284">I noticed that you are moving <code
        data-start="210" data-end="228">kexec_handover.c</code> from the
      <code data-start="238" data-end="247">kernel/</code> directory to
      <code data-start="261" data-end="281">kernel/liveupdate/</code>.</p>
    <p data-start="286" data-end="530">Several developers suggested that
      I resend my patch after your patch series is merged upstream.<br
        data-start="381" data-end="384">
      Therefore, I’d like to ask if you could include my patch in your
      series. This would help avoid extra work on my side to resend the
      commit later.</p>
    <p>Thanks,</p>
    <p>Yanjun.Zhu</p>
    <div class="moz-cite-prefix">On 10/21/25 2:41 AM, Simon Horman
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:aPdVSyLRKeRN3i6z@horms.kernel.org">
      <pre wrap="" class="moz-quote-pre">On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Make pr_xxx() call to use the %pe format specifier instead of %d.
The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
-EINVAL) when given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error
message by showing a descriptive error name rather than a numeric
error code.

Signed-off-by: Zhu Yanjun <a class="moz-txt-link-rfc2396E" href="mailto:yanjun.zhu@linux.dev">&lt;yanjun.zhu@linux.dev&gt;</a>
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Thanks,

This looks good to me, even though I note that this file
has moved in linux-next.

Reviewed-by: Simon Horman <a class="moz-txt-link-rfc2396E" href="mailto:horms@kernel.org">&lt;horms@kernel.org&gt;</a>
</pre>
    </blockquote>
  </body>
</html>

--------------YM5OpauLXSzYUIAt6Id6R7VP--

