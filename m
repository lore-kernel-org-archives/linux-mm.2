Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622F1606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DrEe06rN
Received: by kanga.kvack.org (Postfix)
	id 84A996B05B9; Wed, 11 Nov 2026 01:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC2D6B05BA; Wed, 11 Nov 2026 01:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB376B05BC; Wed, 11 Nov 2026 01:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481256B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:21:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D362E1401A3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:20:59 +0000 (UTC)
X-FDA: 85421840238.03.0EB0820
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2D2F380004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:20:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DrEe06rN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3SAn0agkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3SAn0agkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794378058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Up8Sxm5Z/vJlw6/f/g9Tue73jy4SQVTZi+t46heonUg=;
	b=w6KUcJ/KOhSi1KPbVBxOSkWxBWXcy4YKCIjH9zaA5G21H6tudUk0uISAnPbBrkmsHGA2k8
	3NOGZtuGRTypJTvmK1+6LTo43hLhsS4OIGS1jrXfHtOxsS0fv1gdEK1sKSDDdU4TrBNy2o
	ctDeH0Ud5HQqVyv0p3fflv/P1PInbk0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DrEe06rN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3SAn0agkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3SAn0agkKCIk6n4705nu7t11tyr.p1zyv07A-zzx8npx.14t@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794378058;
	b=Oy9EPs49oRjkcrOyqbfWhllZgtJGlwYhBMgcX0EOUHCLk84ymA27iVAICqTYJmCJDzqYRs
	JfFHmZCL0lIU+JyelhLNwa90XnCacnq/ZTFGRZg7icEK8fysWRatN9cmgX7ByCrW9zUOWX
	a2h2PRR5rXM7cyRNsd46usRhuh5djMI=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c50715e8328so10266b.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794378057; x=1794982857; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Up8Sxm5Z/vJlw6/f/g9Tue73jy4SQVTZi+t46heonUg=;
        b=DrEe06rNjFGzeogohd6DYVNlP+P817KCm9OkwA8vkm9LyM0U4mnRTHddsN5N41XX7b
         n1ylNnVGfOwkp0I7saW68wiK2UbbR3UROj7jG0sPpOM/C2wtWaWrogabROlfeBG44TKp
         O54Tk6n+rFuBNHZY+9UOLGqLtP908By/CcILX+xOkKifBZ8SHGxJJOnrj/YQlvbmmAAE
         d1b64SZHvUxUvYeCa2XeN67voA0CA+hzcCcsK/OCfrW904sP4iiikwwnzimsbQzuxvoF
         nHAG205BsiBfgnW9iUb6DFwj2afJ1VOYmV5Owox0QKhvKVJ6g5ByWAYMxuguft5FpiZ5
         bbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794378057; x=1794982857;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Up8Sxm5Z/vJlw6/f/g9Tue73jy4SQVTZi+t46heonUg=;
        b=Sx0/7vMBw8QOdCIxWuuD8u4RUZPGP+Ih1h62PfnwLKjj6RY8wyPuvC+2yzIGTy1xGb
         Mx6g7BsKpgWKGr5CJPv9T4PIdH7rvVnvj22K30to0oJbkHSmqjSq1M1KzbyAbCrFEF2v
         mUh4TWVOR4MEzMJKlG4F26EcCDz1ZjrC7vd+kKHKmueFh4QWwb4FZGgPOk7yhqu61wEM
         MB37mwr0eiLOZKx0kYYGgPJUPLi1P9Sb3e3u0KHYtM+Dsn1jmQgy/S80vQDBXA89tvp1
         sKx1oK2XorIric3mOXTck116+Q9dzOxSPXakOPvjkN9VbSuPjdjr1JABTfkoUttpUVRU
         o0Zg==
X-Forwarded-Encrypted: i=1; AL+hErHcIfqxvI0N8ux6Aj5g2h2pLhP4i3ZIRb2uWERlvlLwWGlSd4oK2hmGYfIW0DtXcCYo0EFQH5YScw==@kvack.org
X-Gm-Message-State: APuU4Z8dGKe7ueUe1JCvN4B80qZtqOHI4IUNzUNN2IFWsVmFNlvcw30F
	s/5dwI37y4xsnqMUKJk7N/yQXjLB/zlsqtkirFQXq29IurZcRQrqbVHfE6Q5KYOdwwG7njjeiVy
	q/DoUqXaW4FsIPC6/1w==
X-Received: from ejcuu11-n1.prod.google.com ([2002:a17:907:c60b:10b0:c3f:fb8f:67f3])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e8b:b0:c31:8c48:e18b with SMTP id a640c23a62f3a-c5066aa85bemr101254666b.14.1794378056032;
 Tue, 10 Nov 2026 22:20:56 -0800 (PST)
Date: Wed, 11 Nov 2026 06:20:55 +0000
In-Reply-To: <179432062803.2329176.7220119921541924936.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <20261110050202.529473-4-tarunsahu@google.com>
 <179432062803.2329176.7220119921541924936.b4-review@b4>
Message-ID: <9huzy0azq46w.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc via
 serialized pointer
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D2F380004
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ydh6huksj47x9sk4dmcsag5nf1chtqpa
X-HE-Tag: 1794378058-651349
X-HE-Meta: U2FsdGVkX1+ATkXuTnHUsYoLqqD61XvAmKhrjJuD0cC67qE9caAzRSeKJHTZPaXUUJ4hKbowGXTbPUqcRYVeIxihRs1l5BbjyeV+Pi5oU6yzDcHpui/VVyz0qe9stPBDihLtYhAzDDVSGHlcJ/s1qnLZ5n1gyABLJMBI2sayg30TaowutEMaIsOJG7uXbiU944L0OHiQYgCCguAyabzM0UZBzfrCRRr+ahT5bQ0napDTLOScLd4ryZqdxKWjaq1X8tw7ThlZmAY9bAwpbf3IPFbSJ20V+cwu4X86WZ6dU+8TrPCCR6uFQzF19fv1yNYPpwqs7dQLyRUGgH70Ms009pWPMQRFWbNY+enc9ul95KaAMvhzAavvSZUeoyyEZFX8Ea2TTfp75jrssEb0EzpyU2/ph9V04MU+LjPmvc/hKPil+vdpv8p0/ML3n3vNSQ4K7JXd41SfIpFjZB7JVBEfZJZlzAML0QPUNDUTL9ch0/uws1jKlg6eba4Ch23CYsWpZI6q0runI3CvTelRo/tuCw9JYwHkG7GlRnRg1xCK6smfQwddQjAFbGBs9ejOwiEktVo/uyGX61F77/jTQrOHSyouKFM3u32HJHg+Z/wTnRNPseCWUuEzIQHoGXglZtfGK1nBoWdDLsmGVcygm3PghvPgKIGEx1bQKtZ8u64Xvdyhz3ihJYyotrbtsnK8XO/8KzzTLGESvhDs66AHgVogKZMUuzlk0q/uPT7JDlqL15h2DJ9hq40NrNv4woktu5Zy1RPCFcejoIs3wSsO+2RoQP8lzEBWJ1I3lhmtJ3yaRaM/EbRGDv7OT1gy9WOOzMQxkqRz6jUKBFokXo4eMEIi1MBxadfB/2yR0mmly9jqjZVcdcuqpH65U50WYAYhE9A0p517VOGNDW6S+EtQvvbHVQ8j6VoGawK4fvjS6FRpsnCbR7rOmR86KcIYSeI61Q4GEF90Ni0Q0di+ui59B9B
 Bfa6s4r0
 EDJuOU/LMgCR7Zg7NoJyLtpgFiuzJlmFRxTkbZmg0v3+CoBI2vfJv98wnmnL5QSlaFTN6sBp7ded9Igy/Kb5BJbCRV2QIrGD1bES/wVwuNdoZoxyWzPHZdBhKWyW9rvLB0lJHj+loyOIqaw5vNA5wvGiYd5N6uml78WskNBMFB5yv23pP6zezokISTzMmPvEPMEdAVHqhim1/LCN1URkAU1svzWa8mxoh8UR+2BhkglEdChKDaTPEaIftSzzfG99VUpAIbYPEW9UZoxLDJw3pf33COYI/Noc0LU7HEtmqoMcbL+m+jvxz9RKCswvkg0s6ayGtZBT0fPio+edHjA5BmXmIgMECMah/Xz2hrybvVWdLLpNCQI7SAUW282XBL0iu7FLpnW1r/lar12TGFyqPqax0/RINwdF6SxgM9aLlxMtALu9mRmYwr8X1GLIENufpEsukz8d/1xSCKoA/GnrHTGEXlMimpS9Ptg9qWZve9gWzPIqEhoGQkOLD4mDbCn+TYb78kXJWkleboOwFs8s10DLL18rE7vM8PTnpyMGVHbYdXo/QHoGKxS434roaXRXDnaOEOFBAp1Zb0aPjCgU7BCxIn6CrmNVHT7ffzmOYW4wffgegzFzL2mYq0GYT1Q3klrKf5Cqzz2/6m23IxSlKcA+QDjArk4WkqSDwN8dAyu6EZ06bgP0s1oBbQ2evI+JN6cML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>> Subsystems preserving vmalloc allocations currently embed struct
>> kho_vmalloc directly by value in their serialized structures or device
>> tree properties. For example, struct memfd_luo_ser embeds struct
>> kho_vmalloc folios, and test_kho writes the structure directly into the
>> folios_info FDT property.
>> 
>> Embedding struct kho_vmalloc directly couples the containing layout's
>> field offsets and size to struct kho_vmalloc. Any modification to struct
>> kho_vmalloc shifts subsequent fields in the containing structure and
>> breaks the handover ABI across kexec.
>> 
>> Convert callers to hold a DECLARE_KHOSER_PTR pointer to struct
>> kho_vmalloc instead of embedding it by value. In memfd_luo, allocate the
>> main structure and struct kho_vmalloc in the same preserved folio, placing
>> struct kho_vmalloc in the remaining 8-byte-aligned space, and bump the
>> compatibility string to memfd-v3. In test_kho, place struct kho_vmalloc
>> in the remaining space of the FDT folio, store the serialized pointer in
>> the folios_info property, and bump the compatibility string to
>> kho-test-v2.
>> 
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>>
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index 6f12f5037ea5..bee75a7006e8 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -11,6 +11,8 @@
>>  #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
>>  
>>  #include <linux/bits.h>
>> +#include <linux/build_bug.h>
>> +#include <linux/kconfig.h>
>>  #include <linux/log2.h>
>>  #include <linux/math.h>
>>  #include <linux/types.h>
>> @@ -177,6 +179,10 @@ struct kho_vmalloc {
>>  	unsigned short order;
>>  };
>>  
>> +static_assert(sizeof(struct kho_vmalloc) == 16);
>> +static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>> +	      __alignof__(struct kho_vmalloc) == 8);
>> +
>>  /**
>>   * DOC: KHO persistent memory tracker
>>   *
>> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
>> index 376a724a1d8c..7b49dd6d7e2a 100644
>> --- a/include/linux/kho/abi/memfd.h
>> +++ b/include/linux/kho/abi/memfd.h
>> @@ -81,7 +81,7 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>>   *             to directly use them in the ABI.
>>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
>>   * @nr_folios: Number of folios in the folios array.
>> - * @folios:    KHO vmalloc descriptor pointing to the array of
>> + * @folios:    Pointer to KHO vmalloc descriptor for the array of
>>   *             struct memfd_luo_folio_ser.
>>   */
>>  struct memfd_luo_ser {
>> @@ -90,14 +90,14 @@ struct memfd_luo_ser {
>>  	u32 seals;
>>  	u32 flags;
>>  	u64 nr_folios;
>> -	struct kho_vmalloc folios;
>> +	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
>>  };
>>  
>> -static_assert(sizeof(struct memfd_luo_ser) == 48);
>> +static_assert(sizeof(struct memfd_luo_ser) == 40);
>>  static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>>  	      __alignof__(struct memfd_luo_ser) == 8);
>>  
>>  /* The compatibility string for memfd file handler */
>> -#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
>> +#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v3"
>>  
>>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
>> diff --git a/lib/test_kho.c b/lib/test_kho.c
>> index aa6a0956bb8b..cd0f183ff68e 100644
>> --- a/lib/test_kho.c
>> +++ b/lib/test_kho.c
>> @@ -25,7 +25,7 @@
>>  
>>  #define KHO_TEST_MAGIC	0x4b484f21	/* KHO! */
>>  #define KHO_TEST_FDT	"kho_test"
>> -#define KHO_TEST_COMPAT "kho-test-v1"
>> +#define KHO_TEST_COMPAT "kho-test-v2"
>>  
>>  static long max_mem = (PAGE_SIZE << MAX_PAGE_ORDER) * 2;
>>  module_param(max_mem, long, 0644);
>> @@ -34,7 +34,7 @@ struct kho_test_state {
>>  	unsigned int nr_folios;
>>  	struct folio **folios;
>>  	phys_addr_t *folios_info;
>> -	struct kho_vmalloc folios_info_phys;
>> +	DECLARE_KHOSER_PTR(folios_info_phys, struct kho_vmalloc *);
>>  	int nr_folios_preserved;
>>  	struct folio *fdt;
>>  	__wsum csum;
>> @@ -47,13 +47,13 @@ static void kho_test_unpreserve_data(struct kho_test_state *state)
>>  	for (int i = 0; i < state->nr_folios_preserved; i++)
>>  		kho_unpreserve_folio(state->folios[i]);
>>  
>> -	kho_unpreserve_vmalloc(&state->folios_info_phys);
>> +	if (KHOSER_LOAD_PTR(state->folios_info_phys))
>> +		kho_unpreserve_vmalloc(KHOSER_LOAD_PTR(state->folios_info_phys));
>>  	vfree(state->folios_info);
>>  }
>>  
>>  static int kho_test_preserve_data(struct kho_test_state *state)
>>  {
>> -	struct kho_vmalloc folios_info_phys;
>>  	phys_addr_t *folios_info;
>>  	int err;
>>  
>> @@ -61,11 +61,10 @@ static int kho_test_preserve_data(struct kho_test_state *state)
>>  	if (!folios_info)
>>  		return -ENOMEM;
>>  
>> -	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
>> +	err = kho_preserve_vmalloc(folios_info, KHOSER_LOAD_PTR(state->folios_info_phys));
>>  	if (err)
>>  		goto err_free_info;
>>  
>> -	state->folios_info_phys = folios_info_phys;
>>  	state->folios_info = folios_info;
>>  
>>  	for (int i = 0; i < state->nr_folios; i++) {
>> @@ -123,14 +122,19 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
>>  
>>  static int kho_test_preserve(struct kho_test_state *state)
>>  {
>> -	ssize_t fdt_size;
>> +	struct kho_vmalloc *folios_vmalloc;
>> +	ssize_t fdt_size, alloc_size;
>>  	int err;
>>  
>>  	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
>> -	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
>> +	alloc_size = fdt_size + sizeof(struct kho_vmalloc);
>> +	state->fdt = folio_alloc(GFP_KERNEL, get_order(alloc_size));
>>  	if (!state->fdt)
>>  		return -ENOMEM;
>>  
>> +	folios_vmalloc = folio_address(state->fdt) + fdt_size;
>> +	KHOSER_STORE_PTR(state->folios_info_phys, folios_vmalloc);
>> +
>>  	err = kho_preserve_folio(state->fdt);
>>  	if (err)
>>  		goto err_free_fdt;
>> @@ -234,7 +238,8 @@ static int kho_test_save(void)
>>  
>>  static int kho_test_restore_data(const void *fdt, int node)
>>  {
>> -	const struct kho_vmalloc *folios_info_phys;
>> +	const DECLARE_KHOSER_PTR(*folios_info_phys, struct kho_vmalloc *);
>> +	const struct kho_vmalloc *folios_vmalloc;
>>  	const unsigned int *nr_folios;
>>  	phys_addr_t *folios_info;
>>  	const __wsum *old_csum;
>> @@ -255,7 +260,11 @@ static int kho_test_restore_data(const void *fdt, int node)
>>  	if (!folios_info_phys || len != sizeof(*folios_info_phys))
>>  		return -EINVAL;
>>  
>> -	folios_info = kho_restore_vmalloc(folios_info_phys);
>> +	folios_vmalloc = KHOSER_LOAD_PTR(*folios_info_phys);
>> +	if (!folios_vmalloc)
>> +		return -EINVAL;
>> +
>> +	folios_info = kho_restore_vmalloc(folios_vmalloc);
>>  	if (!folios_info)
>>  		return -EINVAL;
>
> Why do we need DECLARE_KHOSER_PTR() in test_kho.c at all?
>
I tried to keep the kho_vmalloc reference after kho_ser_hdr to be
same at every places. But Now I realized it is completely unnecessary.

> DECLARE_KHOSER_PTR() makes sense in shared ABI structs like struct 
> memfd_luo_ser where both kernels reference the same struct field and get 
> type checking between KHOSER_STORE_PTR() and KHOSER_LOAD_PTR().
>
> Here, struct kho_test_state is purely local to the saving kernel and the 
> handover ABI is just the "folios_info" FDT property carrying a u64 
> physical address. Having two unrelated DECLARE_KHOSER_PTR() declarations 
> doesn't buy any cross-kernel type safety
>
> Can we drop DECLARE_KHOSER_PTR() here, keep a plain pointer in struct 
> kho_test_state, serialize a u64 phys addr into the "folios_info" FDT 
> property, and read it back as const u64 * + phys_to_virt() like the rest 
> of the KHO FDT code?

Yes,Agree. I will update it. Thanks!

~Tarun
>
> -- 
> Pasha

