Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1F2F8FA9E
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC286B0088; Tue, 21 Apr 2026 13:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193C56B0093; Tue, 21 Apr 2026 13:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1D36B0095; Tue, 21 Apr 2026 13:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 009796B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:29:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F4EFC4939
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:29:10 +0000 (UTC)
X-FDA: 84683248860.16.15B81A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA06BC000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:29:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqDXLX+H;
	spf=pass (imf28.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776792549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVLE6hI7fsHYiqT7oEwR2XnwFyJMb57cV9W3vS+RJTo=;
	b=nQpflpb5eqp+1kAtqmzvv4X4U/k8+BqJ/dnGJNsaGMOIpkXc/E2Nf0gNjeRTQRX4u9wysL
	61sLGYXBzubasIhY2ySkhhJ56to/NvJjTriyk68+kUJJn0pIWDNsM6N/Mi/F10Vz18GP5q
	m6SajiAkdnaBUqdBZLFyg5VRqqP6jAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776792549; a=rsa-sha256;
	cv=none;
	b=RJfECoKPW/ixcJEoL8AldKK1TPZ+7GzW8MC2n8UHYHb+FEmGI45zXgm9COlLe93FX6cbdy
	kY+U712Ri/qd7lrfOtQAH7iVq25lsyvMiWxLt3naKpYa2LKEPdMDzeWKoG8tFFoRTAQwtJ
	0zcN2ed9LYwRRNI+0DbGizEZwXcxPwA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqDXLX+H;
	spf=pass (imf28.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAD3144141;
	Tue, 21 Apr 2026 17:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87B7C2BCB0;
	Tue, 21 Apr 2026 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776792547;
	bh=vTmrYEHnqYnVUx8iDfIy0TZqyzfVGacK9eDUXDQJOaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqDXLX+HxyI6V99BXd+2HAyODK70u/kQevMvu+wHTmvFW6Ph/nDdSV8HYqDCg3L+0
	 QGlLHdGZWjDUGFWW/9MEoqiXvbBzT6a3djeOnK8YRZQ7cIkh91260YlXM8yxGWRdRI
	 Pv5lyqsUckfkVw+ebbc6iGI0XlBOEQ4teKuGzmIXziAxgdkWWxCP32p1d7cG+fZK1S
	 Cja3jK/IUz1we5+M7xIr5HkVQPZbD0nJyTMWErznFXZvOZrZMQG66FWqOTEOp9wzEJ
	 oUOBKE0ooNo1QPlbLQ8c71fOgARz4t3f3LYmdEbaPjUIJecoUEnAsMUpuWc3SKt3kM
	 oc3j1ohtFmP1A==
Date: Tue, 21 Apr 2026 10:29:07 -0700
From: Kees Cook <kees@kernel.org>
To: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Documentation/binfmt-misc.rst: Clarify "P" flag
Message-ID: <202604211026.C462A59EC0@keescook>
References: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
X-Rspamd-Queue-Id: EA06BC000C
X-Rspamd-Server: rspam07
X-Stat-Signature: rzei69fnr6j46419o9rko6ai5dhbram1
X-Rspam-User: 
X-HE-Tag: 1776792548-575093
X-HE-Meta: U2FsdGVkX18ri0iVpHueaYc5sUutqhgK7C1md/S2iJQFuRIcjXtlfPIGm0T7rxvATzmL79SoUSkQs4otb7zItK8jJFv1Meha7NAJza8S9xRGQYqECBPvc7lwMsiA/RkeGJe01r19/IdGWqPU2nQLNzIYPmLpYIDywi559/aM2OlK9VPlUuthmy1eyHA+HRHwbWwz9CR2AXAvUdcd0ajqUd+NYozsE5j80xbKm7fldkMLi52GyHw0ZAw4FrKdPkQ+jPNJT2iiLDw0gqUAuKgaNdaxvtTDBBRNj8Zea4+8G1H9oXu3IUXMXE0m621XyMqYg8sT/4AZtVAla2tUU0U9yhIVMZ7BOHuxg9IcK54A+Ybk5N/Nf76wu2Hxrc4E3zh430mNCZABR8QALPwvrbnWdMDZL0sEHfE6IB9QZzIIKOXDQAmxFnea9JDVLhVbc0MZ4JFGA+e4c9whDg9kc1Cj6NVv2YXCYxphJlB4IaZfMI7SLjnLubGBT2vbmt3W8648C0sL2f70uqFufem7i1RM5GMdtpgA409vqWunWdIEpcgiJlh6HGmwc6XGRtGUDITU/hn+RHJMygD5qyELExntrgI+UbUifea4ow0gu5eF3Aa1gKZjHGWLeqfFhlmMTm/vNSHMEBa7Gmeir78yoQYNDU2FrVbJBiqgWvjHIUVO03OxOt5eyrw3j2epkWhMwbA3REYkCP+CPPb4XKQAtqCScxjiRXEYPZ7ehKbkW/WG2KkrLTfbSBZFxCKzF5/dFrNS07co6J/PA9H87fo+Z4y7KegyAqfRVoVofke27MuZ8PX+am24hJ5N5T5pY5eisNxt74vGCxTcjLZHnJbbIpoqwyJ/y8Ch1Wfp5PDJLMyfrkHXZarZ8wVVfi5Uu3uxtNBp5uO+stze5QrZ+mLStiYjDRyJ+AL95dIxfHNiUVtGTTCh0lSri6u4EwMifDZPsmlPtIHJXTOe3cmBW6HV+Mu
 KKgKEA2O
 9aQVA+Pphi5uSxCRTMlu2AXxpnijkBOZ4i41rgz28jnYskCjWiX6rCF3VvXkZiCncEesgQYWcalj4X7lymrAOkBt7WHkhzPz07pZpRzNvE5feHFTztmOJq8/bYmLPGDWOKi1Ae1/S7/YnVa3i+ik86OCjvesmKB2kD56O1AGdiRecOGL+3yAIVXrKZEx2LBxsXnX5lFipQ6MBi1OEXo3peY8DQCayWblav6W70nnOHEkAGgd94lAT7SngOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 19, 2026 at 12:11:01AM -0400, Charlie Jenkins wrote:
> Improve the wording of the description of the "P" flag to explain that
> the interpreter gets the path to the file provided by execve and not the
> full path as well as documenting that AT_FLAGS can be read to see if the
> "P" flag is set.

Thanks for the clarifications! I'll get this into the execve tree once
the merge window is over. (I usually wait for -rc2 to be released.)
(Or maybe this should go via linux-doc? I should add this file to the
EXEC entry in MAINTAINERS...)

How did you happen across this mismatch(?weakness?) in the docs?

-Kees

-- 
Kees Cook

