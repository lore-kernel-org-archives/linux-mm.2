Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B2FCC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371F76B00A0; Tue, 11 Aug 2026 09:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3493F6B00A1; Tue, 11 Aug 2026 09:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286F66B00A2; Tue, 11 Aug 2026 09:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034116B00A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:27:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E6F8A0455
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:27:08 +0000 (UTC)
X-FDA: 85089064536.13.B6622B0
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAAD9C0010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:27:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FolQ66jm;
	spf=pass (imf10.hostedemail.com: domain of 3KSN7agkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KSN7agkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHer5Euf93guPyEW5SSggQ6xE9fM7y8lLNbmZzisUY0=;
	b=7WVGW6VMX3aZw4VYCOpxcjcwSpnsA+X6d8yv7gOsCtYK2ItewxZC+yXTDz0Z/7+/FgRSaI
	/cjQ850ZxLL+6kgWYzHdKzvyGOIZxaMmg8tYiL+MWcLlRZMVXf/PkdYotas6L1VQs2Ffdi
	eeeJUthMogfBQWkGEuO29gDh6bHnCr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454826;
	b=aSAfhG8ftC9PoPZKQcRFQv9zvIOHRZy+pO88duDCpUjuMcqoj1cA6EBIe20/Hp0Kq8B5Jo
	iALuAbY5EErSYUR8uo6oRBzge5cheAScB0X0XKwI1xLbOP2BSrv/lnFX5cWTWj9nl4+zhs
	6zimx4+xBdDYXDNx7XGERgbZPn2ZojM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FolQ66jm;
	spf=pass (imf10.hostedemail.com: domain of 3KSN7agkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KSN7agkKCLYpWnqjoWdqckkcha.Ykihejqt-iigrWYg.knc@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c1630a90890so190176066b.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786454825; x=1787059625; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VHer5Euf93guPyEW5SSggQ6xE9fM7y8lLNbmZzisUY0=;
        b=FolQ66jmFAd1wGa56EmBPix0+pRSIJCJZLaa8JZ+CbAOrWYt8ncVMWNfuGv2qSJks+
         hzMloCnP0uPe4KNS3MhNhXjVaxTphfbXBWdd+RzajXnkiVuXb/UyG47C9kJI2H+rFQ6M
         f4Xw3klHhMw7azps472a/7zA7/56CKvSf+MSaJt59oALT+8wtlGPZJYUzpXz6QYCJhl9
         UlsJpOhO/GfZJnaMrAVpJceq7ZS16QODfQOlobhJwaBVJj1IyT/IF9qakOtQpcvCo3Tt
         d+aMpARETUTnKV+8MMLqKtHDLSGjgBSTt0fS+35YqMhlQY3qvZfSuBRUauQJcT/uUDhO
         hmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454825; x=1787059625;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VHer5Euf93guPyEW5SSggQ6xE9fM7y8lLNbmZzisUY0=;
        b=Ogn+FzAZhjyPTyzrrYUTF1l9Q+o/zqoh+lk6LCVl8HWKc0vJMh/gyjIvGTEctCFx1f
         ZF80geArAmzD9FoPfOZvZi+av2Q6MvzAq+GxWSQUmYaSBt+SZfOwWuMYBQZ++5l9gQSj
         4TbkwjhBQhoEdH6XPokj6U1Zbhh/eEI0rnD4sz2t/iBmDFQyxlvXB/Np+iQQ9XlUeTzw
         lKjF0EUTxJo0jJHYoCHon6R8gC9Ugly4tgsErj3tBsqbu8xll5D7EE+1rzFrD38WThPJ
         SfXWL3qhlYLQtbzyceThmMJbLnHaCLMjHicyMfpjUFUi4LbdgDLkT0zwR78mVr66MZ0S
         FQxg==
X-Forwarded-Encrypted: i=1; AHgh+RoKcJ4nqAgzVGbgikfPBu8UYsqNIJyJFNkRIqACgp3pTCHKkaS5wEszHygvVGsHWLM1FDYw0jKp5A==@kvack.org
X-Gm-Message-State: AOJu0Yx+vj2hSrIBtIpoEMA9lLoSXwMlJuNxOlvJ1WVapjEK3Qpww9Vj
	NmfM77B3QS4Nki0U7YGsZUKXSqdZMJwRfPxP+OITGUn+SzPXL+bzzzcEzM2EA9NeNwPU2pXWCHI
	z/BDSwjufcPXNHUtjJQ==
X-Received: from edsu13.prod.google.com ([2002:aa7:d98d:0:b0:69c:835e:2527])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:210f:b0:6a1:b23d:e962 with SMTP id 4fb4d7f45d1cf-6a36c32a68emr218706a12.8.1786454825019;
 Tue, 11 Aug 2026 06:27:05 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:27:04 +0000
In-Reply-To: <anpZMemVz5yC_WLo@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-3-tarunsahu@google.com> <anpZMemVz5yC_WLo@google.com>
Message-ID: <9huzo6f8zt1z.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CAAD9C0010
X-Rspam-User: 
X-Stat-Signature: 1a3sgkciz1gqckat4mjyadfdhh9uin38
X-HE-Tag: 1786454826-814037
X-HE-Meta: U2FsdGVkX1/aghA2m83LcNuAbpaZlUleXREA9+s+VdtDig1RJpjTy93rYN5YCd22num5waGqR3PMS0gifz50pgYiWtkek6G7Z01xgLDsu5HVSlA2BK28v8oq7dwbEn36uvxi9Bm9RD5xebimXYtY/gSEMRkz3CnM/AfagR2J69+xP9Pk3CLM8iUYBfslJxyC63HzcDPHlLPz8g4w3EgCn/aSBu+bFGIWGmdtSJSzz5WwWTtXwqU6RtrzX7zDFi82EmMyS6ck4fPmxKoHKk2P0JTPr7+4oiR5Z7kvp6+5mlQ+GaaryqOXDwuI1fFwBnTGykOKYhphN+rlEWS2vGbL9u9R1Uwdxa5XPRd8C7vHw+8jPBgvPVRQpnk8LVlu57cPGRa32CaTXNYRdBBYYnCWud2NT/L1msPd7jKPLjGyc+8t7Tc6xzF3n/pJfPHomfAGDGeIAAVAkwrofSTF8oKHQp/P1q+hquUUgdKkZDfq3b96FHxMqGRXa4oMsM0oKSrBSUDZdRjM5wnX03k4z1Ac6YJ+0gyUi/8ydIrura8N1f1kOa2V5NnpzKQsETEcHuBrmCgYC1FQgHI0q9iNS+P3VoxboSdrBZB3rH44OLXxlfhawazYMcZo4oO+l730fbZvlhFqAzN3MonTR9Hs/6C5jkcyfw6zc9DCw8SeSe56lpDZYZSI3aaEmyvyUxOf764266HUISRuMxehpsjPfHFcOmOSMKq2jX4t/8Idj23lSJai1G9zGAk74t9o+cVW/daKcMTl8j2huvkE/BwRJ9QJDxrm0Ew/+cIYJZy2cIO3X4n0/uuqWuJiIp/DlhzwX0xQyWok1k9AYGptPTlWoCXNIjjOtC8zPX/qgN1qHruNNt2EK/TiV1CboC5U4MeNi/CupEib37bH6oqerOvi65dxRRDe/fIq7wPybmV2SYOizgtT8p7p0p9eYpoyFn/Wew+YvafRXNphtz9hm0sEhOy
 pbDJsRE4
 ovmtRA/Ef8bQfW3/Y3B7viYww9m2BJpeOH5pJN9AsBlvgrJLRNC6B8MJWl139QfsqxKkkcRkzFVtnuq77tcyf8U/H5lVxO/aAocb+eZkukkCIoESc7ODJskg5WbrK0fAKhBE0TAsem14GdfZG3yatNbjGcnLrMrSNMYEFjiNv4u5uVyfPU5wJYQOPzrk0H/Vz2CXT3y26rRBZhvhC1QfiQ4Y8ItM9eP+L3hi41lT0+Xv/dyBUdK7eFHZVG/NRlBdYjIhR1NnEwgWLAVx/YaVH1oxiMa5Qr78kjHJbzvHbrDXbm5vPm2kMOsDx4SKTTTTHI5aVHnNYH/mSjj2mhVdHU5Mijy3LZUGeaeSxaQzC2+3xzXlTzGR29a/K2GeAkVfWsPUTjt1n214b/Cq4Fkrqrtqohesp0axa05qaEVFy0M9xwG3wsmYV7BztFLTovC2C1hxGXQYfUh5wcLqBnXSV0JhMBFVCe1NiiMopiEmzmvqTgsu+UVDQMzQDYiCWV0+RKtkuTAbhNkigjqFqSrJFvjlSFBpGjDNL2tP6XGDcmLvxjmsZPLqwA/CUqd6BNu/gEV1ncs1yhfnj2su5a5SEEIMFK46DnNenDEnMeZmrQdVuoD+4aQrkPOZUIzM2vJCkYkTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
>> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>>   anon_inode_getfile(), providing a unified VM file creation API.
>
> As Ackerley pointed out, changelogs that are literally a list pretty much always
> needs to be split.
>
> These also need to explain *why*.  "providing a unified VM file creation API"
> isn't sufficient justification.  In general, all of these changelogs need to
> provide more of the "why"; I can figure out what the patches are doing easily
> enough, but in my speed read of the series, it's hard to figure out the "why".

Okay, Will update them.

