Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D60ECD9AA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD516B0088; Thu,  5 Feb 2026 17:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B026B0089; Thu,  5 Feb 2026 17:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59996B008A; Thu,  5 Feb 2026 17:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06D96B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:11:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4AD613B683
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:11:35 +0000 (UTC)
X-FDA: 84411800550.23.7F6AFD9
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48E081A0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:11:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a8siiccm;
	spf=pass (imf19.hostedemail.com: domain of 3lBWFaQ4KCCcMRUGDQULFKDUGVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3lBWFaQ4KCCcMRUGDQULFKDUGVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770329494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9eDseQYzgKZYQrXhIi7NMMbxjrrJgwLrfu5M307gzg=;
	b=KxMurFPE9pWYCEEBLRK9twLthFlXdxJ6gtDSyX+lMZzGDzvya/zfKU1wj5UEzzGIckuCSW
	CHzVcPuNrSJWB1ztcWLBSJyyX0Zw0mBAwQM+LgbNKV/tRFCdidYpbez7V8zD36uh4ZmBSx
	RgMVXsU9yGDnAOtgyZsKnpM2iDoVvKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770329494; a=rsa-sha256;
	cv=none;
	b=BxaPWmPr7iOKl0MOGlHqOn8jW/3YiDnkCqyo5K8w9FrgX1fNkrbBXHSA/ZAIRHh0Hay7MH
	lzZsFtKSWdvo5wzUyKcNZgSI28gZZmAvjhuvAArpSLMiFqo3CxNHs+4XiXP0jwwcNTQ3dR
	1g9QY2PBrUQ9dtMrdmUIlVlu0KCWD0A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a8siiccm;
	spf=pass (imf19.hostedemail.com: domain of 3lBWFaQ4KCCcMRUGDQULFKDUGVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3lBWFaQ4KCCcMRUGDQULFKDUGVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b8343aa8a9so1285196eec.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 14:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770329493; x=1770934293; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9eDseQYzgKZYQrXhIi7NMMbxjrrJgwLrfu5M307gzg=;
        b=a8siiccmWQOkKpzMWCKlJmBtkoKjwVd89Mwlrjlp6a70F917xzj4lfpoRRLXS1mbhL
         vh3++CGDVccYoGe7YwwV0oymXyJpqPb9+JvVVS5pVI056seZbN+dz7bsGTAm4livsQLU
         HjD0rch3Pb1ZayIUU3A4HrGxfL6V1e9UsMeH+W9aNRb4o4lfxlR+5SNU2yUFN0FE7iNY
         pCFmiLGozSpTKQj6jTa2XJbFeVOxA+SwRaq2/A+/GVfm1xsvtW2qZ+Xy8k5RTI6vT66P
         sojJGhrUpJ5u2iqefZVg3cJHuzmyqAccwM12Fc9W15bTR7onVEq8RlxdW0KMVQMHjY4h
         UPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770329493; x=1770934293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9eDseQYzgKZYQrXhIi7NMMbxjrrJgwLrfu5M307gzg=;
        b=dzMT0n8dEviEvmekAeDceMThKE/18bnFOrwO4hJIX/IQnoXav+okCLb1J03Kb3OB3a
         XjDkRmcXwpNoiWenyb4NQsJXh85/tcFqzVOVt8gtuZxSsOFeZb/u2PjMjs2th+2mkdQr
         Ov/eVdvf/qskvAElQxqypwoZsJ7w8XD6VCCcwnWdFm+newQ+lf3UKdsxXHC7SVNKjsXW
         mH9EYO2isd2cGD6xMRisOj0hBlZl62TOH0695IJt1T+QG1QLljvJNmLDOOORlFVktuHJ
         uJrDBR9CkBQmR4iBdPKwqZCkxSCtH1rjjtDWPSurBUCLUr6o46L9MJKNie7fCYEAkcHa
         m5nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaE8JJ+RvT8Vqpo/CPCZIFw7zjUtFzC+0QGmc6mIQUFvFgJIpR5XHnAjqL+SX0j2uHjqsOlXRIyg==@kvack.org
X-Gm-Message-State: AOJu0YwbD+f/aEJelII2XMjBL1NwG4KzH2hVpOCMEWpIKzmkzD4NSEdW
	pLTeFNW+Tm0wBauf7JOVgEBpKBi/noKE1SHYiDosjzwP0B4+dHGvDdFjkPSU6i/AKB7c9Ux13qk
	KgCjYfjqa2gnuTGfcf1GYRDsKsXrWSShIhggaVg==
X-Received: from dybir8.prod.google.com ([2002:a05:7300:c8c8:b0:2b7:4f7a:4d75])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:fb8b:b0:2ab:ca55:b760 with SMTP id 5a478bee46e88-2b856a5bd04mr250824eec.43.1770329492914;
 Thu, 05 Feb 2026 14:11:32 -0800 (PST)
Date: Thu,  5 Feb 2026 22:11:22 +0000
In-Reply-To: <aXj28ZAsPhp7s5sm@kernel.org>
Mime-Version: 1.0
References: <aXj28ZAsPhp7s5sm@kernel.org>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205221122.2415333-1-jordanrichards@google.com>
Subject: Re: [PATCH] selftests/liveupdate: add end to end test infrastructure
 and scripts
From: Jordan Richards <jordanrichards@google.com>
To: rppt@kernel.org
Cc: dmatlack@google.com, jasonmiu@google.com, jordanrichards@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 48E081A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 55igquxz18u81utbxtj8op98seh1i8mh
X-HE-Tag: 1770329494-247874
X-HE-Meta: U2FsdGVkX1+8Kbn/B+DaPAFep8mBdTNNmUwQs963/4z36BcGOBMugQy2s6cMF2AuBtkkm4TVdEXdJHlfYLcM3f3lcgQ+7jKRmH/PBVzUpVnFGyHkY/dybwmZVrHyuqACpwY1j7eCXzqOHoJy7O4GhDjiC5u+oWhnqz1fBjvWNJxUv4FyjSAoUudMrCmfVi2pVkmEN17tEjUdRWzNOXQq3zlwiZYlj7bxVD7jgrPF/Sh8spIYCo6dE+iAgqxhzu9C63q4s7I3s37vnoR00qFTXcEoLxhr5AHNj5wc5O1furMp1WTjHIow47DSfY0arXgytBlokhUXUhMzt+EaWBiwmeuZdhm769h6NCDsXktXpzYeA103cunyt3I2RZ4Y1utzEMDBAe5941odkEVxyhWzAYaxszODBBRTQdKiciGg0eLUZ3RdUuaRN74WDEUGCepEppG9RaCU1NAzehIUYsB6pfuOnf2gBKyVo4QO/eotSta1uql0YpiHCxvokFkqpy4CQTHCq0C6I+LV01xFVMEnW89uZj25XGruv2s2X6fH4E4wa7gSHIS2bOUd8mEu8lPhjnnTqUVbGVFIyvbUIgTbJSZldplsamCR6TxXg5ZOXu2NlXx4V99FwdotxHMNuwQx4ObOo8gpdIPoNEoRx4L5HwYeZRFG4DRJ4qwKLIsapb29z0UhCjmCnqUS9Vq2mAPjoHfnMZKWl9g9QDHaEUfl3HBeh8TYPlm0elPXIsaQ6sViS/A7xljXbi4+vvA5GUyktw6UbZUfs0e/PvwwZrrBiFR1dqsIs+jB/Y529HS0Q4ylhF8a7UNLYAogq11Z0Urn4Fr5TMhLkvSpM0ZigHA1CMcEPrinVvH+P/ZRhsUl2vK6/eB/L7uLMLJqblZKOhpzh4vpCFvTWThqRC+yIpxs+vKbOafxbrQSzKPiI4XmhjE6c1lq+jUDLiWkfBxH5rT+7peiB77AQ7lIR7WIJuB
 /PUQmXK2
 5c4RRK7oHHlQIpGu0tVwchjYAFW/w82aA7HDmkLkn2uT7BUyHggdcrHeXZFYuKh6lsoDlkvOAskhboU+Nulimowf2qHG6MUIDeYQwyKzTkTIvQsbFoH90OjDO0kC9mHzeRP50ngwvRikEBIEHAXF6jD0cSlECpMgbphhX8tbl6Z1I1rJuekbfYSg8bAOxB/bjbrf6ehwYnUD0oqE51Lh8ZsW3ry/QdeBpS1G9/VQ6cK9bZMLD7WHL3Yr+j5zir+EDiOE/GlcsHJhIlY9zXW/QELMQY4nL8EHP5CvZUR2Tt2XkTBbYOBQ6FZuaIhajpVDKcy+/yRBZ2pIONdwCV99LNsPNP0USSXb5EAKUOOn+LDMNzOxSuvIrNw+ypAzFbtlzQC0RVh4VCR3kGY8ypDwItWLe1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sending v2 addressing this feedback soon:

>> +	err = kexec_file_load(kernel_fd, initrd_fd, strlen(cmdline) + 1,
>> +			      cmdline, 0);
>> +
>> +	close(initrd_fd);
>> +	close(kernel_fd);
>> +
>> +	return err ? : 0;
>
> Just return err?

Good point, fixed.

>> diff --git a/tools/testing/selftests/liveupdate/luo_test.sh b/tools/testing/selftests/liveupdate/luo_test.sh
>> new file mode 100755
>> index 000000000000..90ecb16e87bb
>> --- /dev/null
>> +++ b/tools/testing/selftests/liveupdate/luo_test.sh
>
>...
>
>> +function detect_cross_compile() {
>> +	local target=$1
>> +	local host=$(uname -m)
>> +
>
> This function works fine if you run luo_test.sh directly or have cross
> compilers named the way it expects in $PATH.
>
> But if I run
> CROSS_COMPILE=~/cross/gcc-13.2.0-nolibc/aarch64-linux/bin/aarch64-linux- ./run.sh
> on x86, x86 tests fail
>
>> +	if [ -n "$CROSS_COMPILE" ]; then
>> +		return
>> +	fi
>> +
>> +	[[ "$host" == "arm64" ]] && host="aarch64"
>> +	[[ "$target" == "arm64" ]] && target="aarch64"
>> +
>> +	if [[ "$host" == "$target" ]]; then
>> +		CROSS_COMPILE=""
>> +		return
>> +	fi

The host==target test needed to be first, fixed.

>> +	local fragments=()
>> +
>> +	if [[ -f "$common_conf" ]]; then
>> +		fragments+=("$common_conf")
>> +	fi
>> +
>> +	if [[ -f "$arch_conf" ]]; then
>> +		fragments+=("$arch_conf")
>> +	fi
>
> I think the common and arch config fragments are required and we can just
> assign fragments directly and run merge_config.sh.

Done.

I wasn't sure if arch_conf would be necessary for all architectures, but it
is kind of needless complexity.

> +	if [[ "$qemu_cmd" == *"$host_machine"* ]]; then
> +		if [ -w /dev/kvm ]; then
> +			accel="-accel kvm"
> +		fi
> +	fi
>
> Do we care that much about qemu warnings about invalid accelerator to have
> this logic here?
>
> -accel kvm -accel hvf -accel tcg
>
> seems to cover all bases.

The warning doesn't break the tests, so it should be fine.

>> +#include <sys.h>
>
> This breaks running normal make:
>
> luo_test_utils.c:16:10: fatal error: sys.h: No such file or directory
>   16 | #include <sys.h>
>      |          ^~~~~~~
>
> NOLIBC specific includes and calls should be guarded with #ifdef NOLIBC

Done.

> diff --git a/tools/testing/selftests/liveupdate/run.sh b/tools/testing/selftests/liveupdate/run.sh
> new file mode 100755
> index 000000000000..3f6b29a26648
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/run.sh
> @@ -0,0 +1,68 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
>> +OUTPUT_DIR="results_$(date +%Y%m%d_%H%M%S)"
>
> I don't think that putting the results in the current directory rather than
> in SCRIPT_DIR or in an explicitly named directory is a good idea.

Changed to "$SCRIPT_DIR/results_*".

>> +TEST_NAMES=()
>> +while IFS= read -r file; do
>> +    TEST_NAMES+=("$(basename "$file" .c)")
>> +done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "luo_*.c" ! -name "luo_test_utils.c")
>
> I don't like name based detection of tests. Listing them explicitly seems a
viable option.

Agreed, changed to a fixed array.

