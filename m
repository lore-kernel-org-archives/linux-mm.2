Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56B8D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501736B002B; Wed,  3 Dec 2025 03:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8A86B002C; Wed,  3 Dec 2025 03:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416486B002D; Wed,  3 Dec 2025 03:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 313366B002B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:20:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00D55BA031
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:20:09 +0000 (UTC)
X-FDA: 84177462180.15.A093B6E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 058091C000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:20:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cp4z7wutZSCeud7Jvi6yin8tdaPqdTuvYkfM+RNYv4A=;
	b=aptmTgy5809MlEea/qTDYcIZWAy7BO25mqHb86R8SAi6HclyQ2R84vknE5pryt40yZ4Sg9
	rPSAvxPJmbBWZ71ly9O/r5K59mffP+vrhh3oKd+MPF//46LeEvlrUZooGTVaSXLY4+ZFBb
	MTvt6Lu/QKOcfHyJLW9AWOiudoTvwuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750008; a=rsa-sha256;
	cv=none;
	b=1KhlX39Ih6iQlq/A2MN6x1NKI8smlJsYMgMXZ0fRmwAuwqmp47u1inKUNCFku/NooqRr2O
	ca2PkyIiWly1609m1EYWea1dYVn7229qNWMF0KH2oqQCqtfkOiflVgNb0KcwQD19ET23cF
	n69WeC5OLhIGNgKvdrS96z0hXD9BBvg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC81339;
	Wed,  3 Dec 2025 00:19:59 -0800 (PST)
Received: from [10.57.45.92] (unknown [10.57.45.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 199493F73B;
	Wed,  3 Dec 2025 00:19:58 -0800 (PST)
Message-ID: <eb6fac72-a813-4b01-bbd7-f3961894bf53@arm.com>
Date: Wed, 3 Dec 2025 09:19:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-6-kevin.brodsky@arm.com>
 <8d9ed1f1-77da-45af-85b5-78a5da66f1cc@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <8d9ed1f1-77da-45af-85b5-78a5da66f1cc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 058091C000E
X-Stat-Signature: wxqtjdii7rurqio4ic439abpjjcexuku
X-HE-Tag: 1764750007-60158
X-HE-Meta: U2FsdGVkX18vKAmspf59MnutQi5kTrt8wCNKa1V458xI+WTNPb4qs+aQQfkyboLWOaIgA2gVO+G8UWmuX0cGXzvJPhRsW4VjIEEznWulxgsYs5/khEl0NJi8ms7BKbKVdwfIa2tgz814JD4wbasGOHUvbxncnVTM9/YabUJWhnmVq/jy3CmRBWHEzRuxi1zqpw8xWHM0hFz0SmqJWL5FqbxCvzzZKHFEP8XHL4lxY9H1Xol8im59Tk/6We1wmiv5155+h+Dq+tbvUPzbjP+oatoG02GVXI9cvwq12vXmiVCAWiDo+r8DeZKcly10MgGmGvi5ICf8zS7m5PeAxorD8RyMP0zV/2ePihR5a9XEvxLVph8lg+/NRwvrMZz0G6wCJf7QTV2DndjwwnCllMfJ1r/suyQYrNgaSuIK8SZ7OK8MCL6G7hRnV6mr3/FoX6t2WIVeTfADwhGCuIQvul/gCA2VQGtoS5LJOvhOEdAyDdH8mhSSVgH3RwEDxwV0XSg+ptdkUVzhWylu6ZMdSfVsFyQFXxBHqrrIFgLIzyG+KjsCPY7zdhQ82basHfTcu2qeo1iiD2r7yycHv3JprPc9hTQX0VHO62VOUNphEP8j0jepFUHk9bpMOmQ9xT+Vof5werh8svmo/Qn2vZk7Ib2YQTocvsw8RIWwS7566HsAqy/Z3r/xNl+U04JEKLp4l0NU3yhZRxKnLXZQnlU7v2Q46eOVAmdCcMLay4jbPPkhAR+FLGQfrKp3MpWujlgqyjXrI0rjB5JyxU9qrTPz1MgJNXwd9QRCIoPDudt9wMt44yY6uFwYXLLOEad5dEg+jo2q3rFidyuq7faQRpYkJzfNz1GXsaUKXr6ZMtqA09lNljb6fAHMejS3nc3iuD+KmLY+xCefQuOgEn2kO272B5J4vtkhSA8+EdfiWfQRL7uCui05Mp3tfBoKWxWok1eBNzZU5GsqCCGhSItdAyhV4sV
 eYUHcrj0
 9IFOOGTQzMOJudVrVZfVYXpmr5AAas//ODdcjgrlZTEceGOjtK2mjB6dvM7XRN4OBvA3K1Pwp7okPOlEvf0NHhz+lNT0zZWS7tww7vnI8Yj9v+c74rT1VaSb7bmpsiWY+I2HwMIUs0YxzqmBmoCzjp98ZKMI1IMwE80H6DYQbzdsAXDxjD5MBHikoiTXHbKAYjbOjqhY8wW2PKcBqmY0I4MUCQy3r3bOBQQO04zsrg3ZdQ6vJyoMzSQyRzGnxHxl96/Jcu7d9FE/K3TI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/12/2025 07:21, Anshuman Khandual wrote:
>> +config ARCH_HAS_LAZY_MMU_MODE
>> +	bool
>> +
> Might be worth adding a help description for the new config option.

Sure, would be an occasion to clarify which functions an arch needs to
define.

- Kevin

