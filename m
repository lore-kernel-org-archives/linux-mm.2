Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A024ECF2574
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 04:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30AB6B002C; Tue, 18 Nov 2025 23:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE17D6B002E; Tue, 18 Nov 2025 23:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D02B6B0098; Tue, 18 Nov 2025 23:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 877926B002C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 23:09:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A08AD129FD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:09:40 +0000 (UTC)
X-FDA: 84126027720.04.794803B
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DC4AA000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:09:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=hXW0B20i;
	spf=pass (imf15.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763525379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi2rddwojXbTrZJFwpSOry4P0NpvHwP/7WohDB6ZufA=;
	b=8ORmZediLpdvrpMy4upCQlgQf1y/jL2GdzKpK1zsNME7623fLTC9iC5nwwxTLfxxrEv+5r
	fpQqm6vPsS8YRzIJv5/rxezJNfsciwMMHVaiBnheoVYWZJ9iRukijG1gHVBqWWJrPVOR53
	YbDQeJn8SMhvWIlYjLxaWnHgS6DRAT4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=hXW0B20i;
	spf=pass (imf15.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763525379; a=rsa-sha256;
	cv=none;
	b=W9zpolFr4u872bLojLcpiNnpbchOCjivhGH+95i4z0teze2Emk/2c7v8izo59q/NjQOAMO
	VSHU3ch+p29MM0lxLBBqYHNGTaSPRrYZhp16BTUkAbiKQAR976Yf/BtJEf8/OcPMPpZkAZ
	fuNA4qwrR7LJKQnWZqVLAgs0Gm7zYS8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763525374;
	bh=Qi2rddwojXbTrZJFwpSOry4P0NpvHwP/7WohDB6ZufA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXW0B20ipgYdpv947r1CjHIvPM6vXBSpPycfa5qAyjCpI7dvd9yzgeeQ9gk3ho6/w
	 UOj9zpW8j5pe4aP+/Op+G6pY5tT37XjiPUPRfDMvANveUwW+Zi3NXha2P/sEHfkcwR
	 W4buji8Ubz8VZYUg57V5yU9jU+4hvkrGGXrbzz9Y=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 25EAF47D; Wed, 19 Nov 2025 12:09:30 +0800
X-QQ-mid: xmsmtpt1763525370tx4vs152f
Message-ID: <tencent_ACEF6BA50BA908889B631CCED5FF1C244F05@qq.com>
X-QQ-XMAILINFO: MVa6T+CC+5BrANV1TTOpO4+KMwMRZVgcDDvc37ypycJMpmOOTVBOoZR3Y/zkdi
	 Uh764ZeAk2HDJesJr0Q8X86yHdtQNx/cNeFxpJS3G0dJskm9zAQHnjP8B51KDqt3Hto8NNG+69YZ
	 bYL3P9VS9rxgLCx7FxHDERRx0EYxKVSv11z+0Dh2cgkReA+Frj57wW9tyz2DV1H28HbWqhWIRqMD
	 cDddxysh1W5sm0Ft0c0MCj3KvJ8lpvbVz2siFbulWrftXne4O9Xg7RHQ7cTz0zmpJfVGCRL06Pk2
	 bmoPyoHQeLgPVtlpgm7niYUJWz90Z+dUd72ekvn5GokFMC8l2U6cpxpaOqQLpZ+XGpq7nC1p/o/1
	 UewonC/EN2vA39A7AD+U2selJb2XJ7LkzcfFKRQQjwO1EtHgEazP2OvkCv2ATV1bSxVcI9lkxH2+
	 GA7tkUdOeBoZLjXovMGjqbu2dA4xGapJw621E2LgiYQfQ66VyXpccEJAWn7VcTrhj3QZQtpil/Sj
	 obBxFBtbZaXU0hN6oH/340UDZ+HR92oQ0ZSwkd3lK5ICATHSPqidSBfONe9p1ZRb02Fc6mA4u5eV
	 pBpsM+n8qigsrroZ9utvho0mwttmC13VG8emmRveCnA0+xKBB0ckfr8M8LmfKsrEjTE8DenbYv4+
	 /eIc0UueSmZ07N4W1X89VKpR3vax+qrVt4b3rh1bwAylpBIKvGuoytkPDcs7TtfsDpQYaowXJVED
	 yg7CAW2OyCqn+NMitFGpKCzQLQZxVkE/ASvoiCRPkhNPyg/zDWzIc6VsITf158UWh/mEXY9di5Ab
	 8Zztp/icWhM6MjzmmWk6t9apuL3ei7N2eYHlCoI4qt0BB2ImuknrtZWWwbY3KJimpmXHjgbV99xH
	 JenkOZIO45o/dIrgu1DLdFUWnmBHGluaIX6JXugzMFa8a+SfTTkGE5S2Igsw8lbVl3H1nkwpsxTJ
	 QrQE5XQ0EHocKorqDN1rPlLUVRPkJ9hi+oFHgS+og0dwA/wDkNRrXcTH6VlF8UGmecik5wPT0dkU
	 O1B8zLj9Jafqzz88CZLF46CgJ0mP9yGy+xfiEVpLLWDPxfvlR+fv7B597AsxiOgJ7zrPhm0AKv47
	 iRIXgIoU4IqrMT9Lf8lvNprSbSemHAwly5r0MtUtJ86DEWF7o4pt9+Kdon0jJ3QVhWL1CNqEljO7
	 2oBj1JO2t2k7UlvA==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ywen.chen@foxmail.com
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org
Subject: RE: [PATCH v3] zram: Fix the issue that the write - back limits might overflow
Date: Wed, 19 Nov 2025 12:09:30 +0800
X-OQ-MSGID: <20251119040930.2875269-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_C9BC3F2FE38BB1EBA44887FB683CD195E705@qq.com>
References: <tencent_C9BC3F2FE38BB1EBA44887FB683CD195E705@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DC4AA000F
X-Stat-Signature: g1q63doxbprgpe7q9dcg4qpswbcekc63
X-Rspam-User: 
X-HE-Tag: 1763525377-421090
X-HE-Meta: U2FsdGVkX19XWb+BFHqVL2StYavPDOuzIzXsu6GQDcZL1GkUPKiXFXHsy9RS6dpSsttPwlASXi64FWX6UkVKvfVITNomLioihtk7hB3i1BEqeBYC8/MRIxVXOyv5fdL83RdHvmCgwekeZP5gGvgV+XrpU6Ym5nASBTrlXuElHONKsWtWKQ+aDHZ1FCUPlmnrLE3pzD59B8Nbc0b67AFPt9fQrjqsjeSNN/TTE8fcY3ynkDRIKYxkPuTmchHxXoyACsAQwVhX39kL2lq550HgRSgs0KN9H/fXFgM8pOxAWVF8ToEPoP8S8K7sHyv5WzNwbO/YCCldCaSdRBe/HSfsle5UzEadUrhqQQnyJRvICFoThqP7RuhGpDU/XSuZw4IWG+xMGMCxS0JxOfu7SD7FqzS9QUEtSbGGrkh9/HsjZhsrEKQniuXMSUcCfG4I1Mb0JcMnhGLTro9l+K533PxCmM/ZEWEefetK2gJv2RexGNbATD0vNZlmVmD2BnskWbo/ZqWZdGzAqFfc9QYnSs2etNiUSUjQUcbRjsxUL/dZndHnoFYQePl3q08G6Mdag0Yep+6FJIsT0Lt3/YeSA+EArDxzkF3A8y05gqZFl7XNkQfKda4QU72agTSbDaWhozNXPye8o1GyTQd6N38PgqnyA+uS7jXrlt8Y5L75QW9GrKIrsCTZ2MERsUMML4y7p5sb45cuXt/M06eMaMXulXJga9f5DkHxViQ1Nzz8MLXxn73lmo1Ei16vZ1/vPxkdThmqHSaJ76IUJRnhkEojlVPBcfs/NKKPEkT9bXCaXyu8owEYtHxj8p6ARyu34o1YCGw3Y0RJd9QpCRsg1yN0LJtgZYgjwgZSJUyrRHWIH+Pr2qoq7eeqhZM8CVFD58V2+xYRBe2EeL5w1axlu/zlU6Sv31GobfjXPCoS3Qc6JeYRJp/udv+ck8DjafByMERMuEpSFdCXUoI94OdigH71Ilv
 lPVLcP1E
 ajJYJvVY6cTfIyyz1jPBDxZ1eqMfM5mCv5LbmN9HU/lefB+XNZhYWTa2EWXrTVHHaQEqmsWOcNTcBZatVPmBT87txmwizwfKHoPTWJZPxP1t/AGP3MImlwQljOj7uSYNn+A7bDUNSp4ZWMWN0LgIHVDc+Z7zogZLGPsn03T+mC5nq2BBSNCG2HLx20bZspuDjlbVjNRDDBKge4yZYFaPiwGcBPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001377, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 12:01:57 +0800, Yuwen Chen wrote:
> + /*
> +         * When the page size is greater than 4KB, if bd_wb_limit is set to
> +         * a value that is not page - size aligned, it will cause value
> +         * wrapping. For example, when the page size is set to 16KB and
> +         * bd_wb_limit is set to 3, a single write - back operation will
> +         * cause bd_wb_limit to become -1. Even more terrifying is that
> +         * bd_wb_limit is an unsigned number.
> +         */

Sorry, I forgot to check the code format here.


