Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338E6CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D4D6B000E; Tue,  9 Sep 2025 21:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DDB6B0010; Tue,  9 Sep 2025 21:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CE86B0011; Tue,  9 Sep 2025 21:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD96B000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:00:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC71A867F5
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:00:55 +0000 (UTC)
X-FDA: 83871536070.26.F1179B1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 418ED100005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:00:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AMFtqSnI
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757466054; a=rsa-sha256;
	cv=none;
	b=imv2tzGS52jdyYuPgaornywA8Vbz6ocgThgCVrPeB/RepcnRrCxddoTMzISwUUq2HBqCxu
	zlLy/FuwWL3UgSHNrbuW+S51bwpflL77WO7KhqLeuI1WFCj1xtmK0IMjIDMpQVfOPV1xrm
	+TkkxgiF4SiKXStrNTkXdl1ON/lopaA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AMFtqSnI;
	dmarc=none;
	spf=none (imf14.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757466054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCovnQiKBqc8KwjIgSafo1ECvn4VKWgvcShqCm4XuY4=;
	b=6YDPkKUkMi/mEC5eSoMU9wraefdyQRzeIUur/12bRwGYFVqSOLpNhFpXo+crzcWAbB7Gbc
	bgbIIBTU+jlXbrLosigonHpn9YkwjhvTXYqJNu0RH0a21k+VHPSx87LI6NR6SJpshRUxi2
	Phm5rCqcQJ4+xQnM3ARM0V/SRNAZPIE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=VCovnQiKBqc8KwjIgSafo1ECvn4VKWgvcShqCm4XuY4=; b=AMFtqSnIawnRKyNrClfcd16FmN
	SlVzBqWHt3rvR9TpQ7Z2cu+fFLU3Le2wCXeAad6k+WrECaIO5uGrBSJI9/QGWxzwOGXLd9kgPvulb
	Y1PO9k1kNuDanrgLG6Ye3buIIMYb/QcO7t+gr7BxhHdC77dmF8OV54NJfIWqwaz7KBFlhNAqKY9nV
	oYbNSw+qdhrleALXGepsklRWB+c9ZdlDCGP8YlkSFwNbacpXaDdL8z+HWJ/9b2/axreLrdTNir+0Y
	yW0YK+zDEsavCu6hNmok5zv6QL1Hefpl//X5VqECRL6CZ4Xm0jkV04EsBGdRrMqvkgkyCI0I0xV/F
	gqaoZuSg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uw9Cc-0000000BHYY-0xlp;
	Wed, 10 Sep 2025 01:00:50 +0000
Message-ID: <4e230009-ed70-4260-ba61-170ddab17a80@infradead.org>
Date: Tue, 9 Sep 2025 18:00:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] Documentation, kstate: Add KSTATE documentation
To: Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 James Gowans <jgowans@amazon.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He
 <bhe@redhat.com>, kexec@lists.infradead.org,
 Pratyush Yadav <ptyadav@amazon.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Chris Li <chrisl@kernel.org>, Ashish.Kalra@amd.com,
 William Tu <witu@nvidia.com>, David Matlack <dmatlack@google.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-8-arbn@yandex-team.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250909201446.13138-8-arbn@yandex-team.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 418ED100005
X-Stat-Signature: 5gq5zpt3dc8g6mgojbo45qbsg3rpqdko
X-Rspam-User: 
X-HE-Tag: 1757466054-974411
X-HE-Meta: U2FsdGVkX1+9+A5lGODwgdfVbVikMuGJqcDCSbnVAIX/nvJ6YWIQYvUo22J8vr+ephgkYgHPXLZpMIdIzUakE6siGodmUbtMqerxWIICt/i8yxwByYbAcmvhTvhUGbJAtEun5lvrEFYsIuMp7Sb2Q5CpAKvVPh6Jem0kKHLZJ31J++yd87ZNC8hUS0K99LbNHNFSUOtSFcZcKtJ7jlprIbloXlEwb1Fj+oIUb6jP+QSSacqpMJI46JquRAj6cnefHcYdlloGuEkZlvhl015Qmu9i2l9KVgEQmWsCoAyxQtHV6VxsUv7KidK9cWSclNUyhZ79nSzpmFkTHd+lAo24oUNpOx+o2uimty8gHESpcj5Sf6UJWpEBcGTLpM9i7Jz4mx9N2N8xZDiei3WV+cLm8UVIfPNDXHl1P9ayst3DiLc3te9Ea+umOk3qKGjFBXQVgQuddOk1DLGkKUQZX2FXin/i5Nz588tzIkoA6s+Rup/FIz6s+aHyUflj1igl+Y4Ls5anmNEAJfKDys5UmQ12g1eg2RluTEII6vSG8CtZZcdvxEM2GS18uWrWfQuEKS99j7WS2CXdwo4B+mNAMf55nEc6C93+O5oDwURdiVnKKKGKkTb5Gu1JPaJ8+mmPNBlWfvn94OHXAoCdAOFWgNFfw9u9YkUAFovDb3MUERtSZPchr/TNEJbKjcDmOp6jX9DNJmT/Wa2a/nngDS4+DHqsuQgfv7xNlXvetbqix70ed/svMkHB/nH0kzFrQ6fpKAabtybxLl7G5v2d+/L41pDDthpdd8UjWV/fSQoJ3FOx35rUXkaq3Ai7Amnpu//rxauRx1DgC7nAihKly0syy7UX/3qmUajcH59GyZ1QwHGIR9fswA3+x24eEO3OTNXCTolNKzCb7oC0+QBfAlSsFa1+ZJpzQBANv+hwpu9qQQn2f4D0EIztX0i/8LSQsJeTfpHePcBHXX/YNFroEw3OBB3
 gnAJGcLF
 PuOwwP3YbM19hIEtIC136Zgbk3jIKwEnywYnDo/UseO8tIgkZfg28BHI7Php0eANZdSeC0ePHuZg7X7KWfX6mKW5NQcHqmUOHYThm/f7ScCQ4fiucDuVWHes9/DysWs9axGK3AK3f1GOCzTF1YdSXraHWSv41sNfnGyBD7HJD/7o7HYf/mYVrPxK1NwgIvb9t7DHiCW8e+MuUo9h1zwfT5rxCC8p6yN8alhNGFy5Vp2MY8I6FLEJyygdXfCjmC1Gdmtye6A/hIfXGvg+x6rrQQGXDyEGe7EOYX0k0C4Ru/cSP0bp9Z2OkyHtwmoSC/rM5HV/wDL7kIRT2aKg66UnRRkFOqS7Ban6/zAwu8IQTU9MUgve18WLbn9NNng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/25 1:14 PM, Andrey Ryabinin wrote:
> Add KSTATE doc. Describe 'struct kstate_description' and information
> about versioning fields.
> 
> Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
> ---
>  Documentation/core-api/index.rst  |   1 +
>  Documentation/core-api/kstate.rst | 117 ++++++++++++++++++++++++++++++
>  MAINTAINERS                       |   1 +
>  3 files changed, 119 insertions(+)
>  create mode 100644 Documentation/core-api/kstate.rst
> 

> diff --git a/Documentation/core-api/kstate.rst b/Documentation/core-api/kstate.rst
> new file mode 100644
> index 000000000000..981ba162109c
> --- /dev/null
> +++ b/Documentation/core-api/kstate.rst
> @@ -0,0 +1,117 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +KSTATE: Kernel state preservation framework
> +===========================================
> +
> +KSTATE (kernel state) is framework to migrate some part of the internal
> +kernel state (device driver, memory, etc) from one kernel to another across
> +kexec reboot.
> +
> +kstate_description
> +------------------
> +
> +Most kernel's state is in structs and structs could be described by

   Most kernel state

> +kstate_description. E.g. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> +
> +struct kstate_test_data {
> +	int i;
> +	unsigned long *p_ulong;
> +	char s[10];
> +	struct folio *folio;
> +};
> +
> +struct kstate_description test_state = {
> +	.name = "test",
> +	.version_id = 1,
> +	.id = KSTATE_TEST_ID,
> +	.fields = (const struct kstate_field[]) {
> +		KSTATE_BASE_TYPE(s, struct kstate_test_data, char [10]),
> +		KSTATE_POINTER(p_ulong, struct kstate_test_data),
> +		KSTATE_FOLIO(folio, struct kstate_test_data),
> +		KSTATE_END_OF_LIST()
> +	},
> +};
> +
> +Changing data structures
> +------------------------
> +
> +KSTATE saves/restores structs as a series of fields. When the kernel structs
> +are changed we may need to change the state to store more/different information.
> +
> +Versions
> +--------
> +
> +Version numbers are intended for major incompatible changes, that are not

no comma
Drop "incompatible" since that is implied in the rest of the sentence.

> +backward compatible.
> +
> +Each version is associated with a series of fields saved. The state is always
> +saved as the newest version specified by ->version_id.
> +But loading state sometimes is able to load state from an older version.
> +
> +There are two version fields:
> +
> +    - version_id: the maximum version_id supported by kstate_description.
> +    - min_version_id: the minimum version_id that given kstate_description is able to understand.
> +
> +KSTATE is able to read versions from minimum_version_id to version_id.
> +
> +There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.
> +
> +	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
> +
> +only loads that field for versions 2 and newer.
> +
> +Saving state will always create a section with the ‘version_id’ value and thus can’t
> +be loaded by any older kernel.
> +
> +Removing field
> +--------------
> +If field is no longer needed it could be marked deprecated using

   If a field

> +KSTATE_*_DEPRECATED macro and bumping ->version_id of kstate_description:
> +
> +	KSTATE_BASE_TYPE_DEPRECATED(k, u16, 1),
> +
> +The last parameter of the macro is the last version number that have this field.

                                                                   has

> +Old kernel will save such field, but new kernel will skip it on load. Also

   An old kernel                        a new kernel

> +the new kernel will not save such field (as there is nothing to save).
> +Such change is not backward compatible.
> +
> +Adding new field
> +----------------
> +
> +Addition of new field can be done as version dependent field by using _V form of

            of a new field           as a version-dependent field by using the _V form of


> +KSTATE_ macro:
> +	KSTATE_BASE_TYPE_V(i, struct kstate_test_data, int, 2),
> +
> +This indicates that 'test_state' only from version 2 and above have field '->i'.
> +If new kernel sees incoming 'test_state' of version 1 it will skip restoring '->i'

   If a new kernel
or
   If the new kernel

> +as nothing was saved. This is not backward compatible, as old kernel doesn't

                                                          as an old kernel doesn't

> +understand the new V2 'test_state'.
> +
> +Subsections
> +-----------
> +Another option is adding subsection to kstate_description. A subsection is

                     adding a subsection

> +additional kstate_description which linked to the main one:

   an additional                 which is linked to the main one:

> +
> +struct kstate_description test_state_v2 = {
> +	.name = "test_v2",
> +	.id = KSTATE_TEST_ID_V2,
> +	.fields = (const struct kstate_field[]) {
> +		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
> +		KSTATE_END_OF_LIST()
> +	},
> +};
> +
> +struct kstate_description test_state = {
> +	......
> +	.subsections = (const struct kstate_description *[]){
> +		&test_state_v2,
> +		NULL
> +	},
> +};
> +
> +
> +Subsection must have a unique ->id. If the receiving side finds a subsection

   A subsection

> +with unknown id it will be ignored. This make subsections suitable for backward
> +compatible changes (migrate from N+1 to N kernel) assuming old kernel is ok without

                                                     assuming the old kernel

> +information in subsection.

               in the subsection.

-- 
~Randy


