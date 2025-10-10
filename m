Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B06CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 09:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86C48E001C; Fri, 10 Oct 2025 05:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E9E8E0018; Fri, 10 Oct 2025 05:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AF58E001C; Fri, 10 Oct 2025 05:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93B8F8E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:10:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F55B14021C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:10:36 +0000 (UTC)
X-FDA: 83981634072.09.96FABB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 16B3614000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:10:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760087434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGJOtgJqUDDheKZ+OKzpQj5WOTRkV0Ez3gQzJtKX/3c=;
	b=xC4AZwSCYR8zaImqCh8bEEL+JbBemOWeqWKT/DGWD6Lf9pPz4+PnhtT5IrAd1JAoX0r8w5
	Tx/r88lWmU7JUpZmKwre9M+F00uqauV+5YDWbg25NAcnj8sjmYRMWEFbjiOZNTElxA+nW1
	109G417X4sMwMbO6lV+LvHj+dQoVKp0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760087434; a=rsa-sha256;
	cv=none;
	b=NV18Hp6dSVHB9insxvDIfvnGYfFTb34zCb++9qcEKkgej9TnRuc8JAPNoR2PPwf7q0NP23
	Ow++X2QodUDqxFMCWHqvQqHpoC5DzNDvN/gWVSr1xzyNsD9rRQ9ACNuA0LCjLlXl03Kb4Y
	dz4D09Ya5UsSRB8dafYv3aGW02RCcyY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2AF11595;
	Fri, 10 Oct 2025 02:10:24 -0700 (PDT)
Received: from [10.163.67.26] (unknown [10.163.67.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5B573F738;
	Fri, 10 Oct 2025 02:10:27 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------m80SJ9T5Purf8vJPKupn4SlU"
Message-ID: <ce95ab8a-70dc-4159-b38b-dd9f3ffc9aa1@arm.com>
Date: Fri, 10 Oct 2025 14:40:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251008043748.45554-4-lance.yang@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16B3614000E
X-Stat-Signature: uq189gem9s11ytja1mqdhcrb173mcgpw
X-Rspam-User: 
X-HE-Tag: 1760087433-840580
X-HE-Meta: U2FsdGVkX18XiljQs/IsrfZC31vOB81hkz9z+HFyqt0HC4lJxbZIq3vjNWogjUbdUSogVTNfhN+5UX5hpRs6A/zlBXK8Bdb3zpXUqJZLq/UZlBBVOMmR17B7BuXB7JQMADWJkoE1MWH7ltEkPZigXpZwUUYWiRz3AFgtzZP5tX8p+u3+H7cIyDqTn05jac02R9CRjHsucC+uF/RFrXRHXwwSqC7pxrCkvslWwTyQEKuAnWGQLD111Lm50r+dxQYhDWDaMPcBX5eDqt3cTNdRtFiCn9V7b9lw5PKMKjKDEluryBWIi8YfHmHQf1Y06GKWQMjohwvr5ID6tDStE1QGqvGio8oRbU1OeluvEuszC05lTOdlpk9/fXfbk8nJMm52VZhGnE29R2j2hD0g4B7dieoHnL+vkVBfjfAgI++pvnah7E03iil0l8lO+kySDRGj74MSDPKuW3lfA22XDz/XokCrEYQK7U67Y0Ovl0AgCSSq4gJ7HPg5L+aUCEiB2KyLTPhHbMDWwJLBahSE8cZbfj5K8I3LDwJ2TFngSNH2OOSZTlZE9I4yXIu4FTzHEbl9T54oW/WPu4qRqyT2b+TKNGcv0yilzomBoD50DbZPQVB9n0/g6Vss3s7gode4DNDHe7IOcpWLkt6kPcniBpcaTZx0PzOvqGqvPhAZdF6JCEOV9iKTTBkpLqHCs2Wvb51uMrPG2MpOXA1a5O202N34ItcxYqBS2AZJ8YKQTXqKE39M01Lz5rAPpNkTR54yScq7HxDgwF2BFtnRsCeJJhSvP5pM7QVGEE5shdJVAidFKlwC3sHC/jxCfQLzRWHTcIBPAyE212vnN/igdJAh8bI7BNWP0CxZuScb5vYMsJDghFWvQ6fxUh8iIWuGITF5+/Sjp+YiJogN1FBPP/lhye4Ok22okSlwn5yC/hfYUQhE5HZMat2kM03jBhCpScB8JaHFkQ8Ii+BkGbw+irGdGt/
 8J438OEc
 Wz5ja1QxcskY9DkL4f8we/goFKKxCl+IE7qCXqpg4aBAXHDwqNxAfL5x4WsmwRPB5jm1pVXRgclIziRoYb6Fob7gxsHScaviaUcygQ7JVP+VYXNMBPQWlGLc9nVV3Vyh/Ikz/LGsEGXhMlO/VXh8uvrdQtk/SzjL27aT2hP/eNKxaZIZ1iHGjghKNNoTmPY9jJ09z+BMmoRrUtng5FRSZ6r4Wy69NQt9LK7VoEzfAUw17sp53sDSg04L32JsGQMSUI5Kwjz36Y5gYTceWEkLusYYCDller7JL9VFD+1YP1+cVNq2R4bVpa8q7kuhHpdSkmRSF69SqPwacPJS1SP6tu1sHya6TbxsVzHCo148Io6K8vuxX8POBFj/8xn85Xu2HR+U8sGK4Kb7EgbDlI8OlKB3jl9FRdNf9SxaM5uk2yIeVmK3mPJyS6A8lng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------m80SJ9T5Purf8vJPKupn4SlU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 08/10/25 10:07 am, Lance Yang wrote:
>   	}
>   }
>   
> +/*
> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
> + * @pte:           The PTE to check
> + * @vma:           The VMA the PTE belongs to
> + * @addr:          The virtual address corresponding to this PTE
> + * @foliop:        On success, used to return a pointer to the folio
> + *                 Must be non-NULL
> + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
> + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
> + * @shared:        Counter for shared pages. Must be non-NULL
> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> + *                 PTE_CHECK_FAIL return. Must be non-NULL
> + * @cc:            Collapse control settings
> + *
> + * Returns:
> + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
> + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
> + *   PTE_CHECK_FAIL     - Abort collapse scan
> + */
> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
> +		unsigned long addr, struct folio **foliop, int *none_or_zero,
> +		int *unmapped, int *shared, int *scan_result,
> +		struct collapse_control *cc)
> +{
> +	struct folio *folio = NULL;

I think initialization is not needed here?Otherwise, LGTM. Reviewed-by: Dev Jain <dev.jain@arm.com>

--------------m80SJ9T5Purf8vJPKupn4SlU
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 08/10/25 10:07 am, Lance Yang wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20251008043748.45554-4-lance.yang@linux.dev">
      <pre wrap="" class="moz-quote-pre">
 	}
 }
 
+/*
+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
+ * @pte:           The PTE to check
+ * @vma:           The VMA the PTE belongs to
+ * @addr:          The virtual address corresponding to this PTE
+ * @foliop:        On success, used to return a pointer to the folio
+ *                 Must be non-NULL
+ * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
+ * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
+ * @shared:        Counter for shared pages. Must be non-NULL
+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
+ *                 PTE_CHECK_FAIL return. Must be non-NULL
+ * @cc:            Collapse control settings
+ *
+ * Returns:
+ *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
+ *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
+ *   PTE_CHECK_FAIL     - Abort collapse scan
+ */
+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
+		unsigned long addr, struct folio **foliop, int *none_or_zero,
+		int *unmapped, int *shared, int *scan_result,
+		struct collapse_control *cc)
+{
+	struct folio *folio = NULL;</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">I think initialization is not needed here?<span
    style="white-space: pre-wrap">
Otherwise, LGTM.

Reviewed-by: Dev Jain <a class="moz-txt-link-rfc2396E" href="mailto:dev.jain@arm.com">&lt;dev.jain@arm.com&gt;</a></span></pre>
  </body>
</html>

--------------m80SJ9T5Purf8vJPKupn4SlU--

