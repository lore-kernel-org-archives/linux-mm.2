Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905FECD6E69
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4036B0088; Wed,  3 Jun 2026 02:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AD46B008A; Wed,  3 Jun 2026 02:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B82D6B0095; Wed,  3 Jun 2026 02:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA2C6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:50:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B1E9A023B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:50:33 +0000 (UTC)
X-FDA: 84837677946.20.3294B66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B320340008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:50:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LShkk0mX;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zkZsKMId/YpcSM7hRk7+yk937t56AhH011N2rP7/HU=;
	b=IR46GlemdgT8leJZpE94xtwb516vN+wmeYciJnJxeQ7PbNSW84/j8+slr5W3q7Mag6D5mN
	FeNkIFy7qizcS2uQm2dHYv4Ur2mB/fud18tzIAFA+YMIJ7FQAlysZZ38UXeXsm7Sc4RlLS
	xTRSBP4eTpXWxSwvriRuv7qR9jQQ9Jo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469431;
	b=HoMHGvBgcrSdXd1QnbXUJB2a9IswhinUIFujyC2vOgN/zF54aUhNO7rzS0/tr+GsvCgzN+
	yGkp0TdnHnIjEFoGdTm+zwp4JOBTs05CPDQ44J5WRdhkhNGIOkkfaJgUmyWnM25O+vsRWp
	ToFu9hoQcsxVB6ceh/uf+/X/qVa7HDg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LShkk0mX;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38ADC6008A;
	Wed,  3 Jun 2026 06:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60AD1F00893;
	Wed,  3 Jun 2026 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469430;
	bh=7zkZsKMId/YpcSM7hRk7+yk937t56AhH011N2rP7/HU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LShkk0mX0KeH56YPbAj9udunVC0/Bl9HVjj38equoJu/PY2D/YeYYoAdmJRKW7u3s
	 qijI1kpk3dHIzo5IDY1tjLWNcJ0qfNcf9/8Y2Eme6801b5dkPJjNbniIrd/Cd3j2c/
	 o3AIGVlfw6LXkwgVxVd87Za6wC8CwsUvyleXhstg0LtpyNd/2nkyca1zFSbupiXXjH
	 TDpjMeFZLUngtjIWb0PAnxicLGJdIGNa3Mti+XUzr8OVxxxlBoA3RQ3NNH+TvAg2or
	 dWnJeuhushF1/8z080jM/wQQx+WQED3ZoufYUusCIw2H4skiREq7Ij3wagv+wfoc9F
	 mkrZ1oFfb4HiQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 04/13] liveupdate: register luo_ser as KHO subtree
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260603032905.344462-5-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-5-pasha.tatashin@soleen.com>
Date: Wed, 03 Jun 2026 09:50:24 +0300
Message-Id: <178046942429.468621.9591914636403075487.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B320340008
X-Stat-Signature: fksu6jss8r1pxjoq7y6ki7t9ayub7j68
X-HE-Tag: 1780469431-830931
X-HE-Meta: U2FsdGVkX1+h+tubVgK6A6n/L6YxeY9NAJcW9144rQV8m2uR9tLRvspzm1iG0g0wi+lv5nYqYUH08ulB2pdZ6/2eXFHYlzuWQ2qk6Z7BiL9zA3gJEG2vXRoNZPBjbKywnGekKegB0zw9nts0Qjm+dE5H1FOFlQ8+q5kdHj1ddbxY6PHOYOdUJOg153V+puAd3B8cgygIc4O7LxdTTenohRbs9hF6eLia/tqPECPSWDgBGL+tzGKkLnFvuO0JZFl+HCd2WchhocVdTXkB28gbALvRXJwIb95w6yINXiQOKbAXlBSj3q0UUs29SayQ0FS+ky0nULfV/0Iwnf47o689KynRz6Hcej2Pp1o+JD/um5lZG+jQpkYXy5Ou/Hgzb+Rw782DQZ15cdDA2JX6Oyij3nlb7QdzY1+MLmRyKspx61J+b/W/Hk9krm1cdsqbKceDDW97jKIwnqCtycdAyesQzRiSok6mBBFq7LBVax4HDSF3rP35FtcDquAMBD5LcV17hNEBr67bd5yGSfHP8nrCqoovD9zJ4ow9QAJn3pB3PSLBSiXAkEhsavwCQan0i4Bg2pYoEopPRUOxHvtVeF01WOMIVCDrFY8gooDTnmvMZC+DveXmkkLPZyoPKX58zD0q7shFlQYf184R4M5HnGqE2PKIAjtmLE3WYWoR/8DScuVap5jMkUG05kaSjZVf+EULEVjUCloJiCM1uGOt2uOPJYBoCzK01YDcFtm+2GdzVl4uFL394sni5pkekstOieq8W0wwYttU/r4BAwo5C/3z7n4TSGpZKlsTGMU1wIPPrKKkSyhZYWHng6daqqio9FhxPmuStVjK963XqFoASvHKaE1ko5K4FpeNW5kA6pFqqT+Oo0aYFIFoT8N6M+wlw+6fwiTNQjAElJwugHmbExCo3DtEKEs9qFbVcm2oBRQ+EXfmgrD+dE9xqowXftmGUfQPY+fKg/ghSk+wIGjtai7
 KACu/gal
 RDh2BTcMHgM0VDsw07uhQH8VMp3ci9vQ9wKL7XLWfzWHIfOsNRmhaAjGJK24JOECIRVmJJPCUbKFexD9mHGCyoNb7AZ/b3xscsAszd039ZssUI3zkTPZD6NIN1vrUmUxN9klSxgiGGyTFyw12fniQPzE7vwcRKP6+XGDrDrhOFPXa7ODJxLwPvCX5IXg3N0U1vyW0dOVMXylTaLLQ2c9TGUBDLFVIYzc6PpfBxL+5ekx5FD9tbqsbbb5652UTkMRY4tyrnRISoFfnhutrVSMxQC9OA9946XrxIeuNhqe2cNqmhaL20kvLHf0Uf3nkuFo7eT5Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

# Add your code comments below. There is no need to trim or delete
# any existing content -- just insert your comments under the relevant
# lines of code. Lines starting with "> " are quoted diff context and
# lines starting with "| " are comments from other reviewers.
# The final email will be reformatted automatically to include only
# the sections that have your comments.
#
> Entirely remove the LUO FDT wrapper since the FDT only carries the
> compatible string and the pointer to the centralized struct luo_ser.
> Instead, register the struct luo_ser via the KHO raw subtree
> API, placing the compatibility string inside the structure itself.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 1b2f865a771a..9a4fe491812b 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -10,11 +10,11 @@
>   *
>   * Live Update Orchestrator uses the stable Application Binary Interface
>   * defined below to pass state from a pre-update kernel to a post-update
> - * kernel. The ABI is built upon the Kexec HandOver framework and uses a
> - * Flattened Device Tree to describe the preserved data.
> + * kernel. The ABI is built upon the Kexec HandOver framework and registers
> + * the central `struct luo_ser` via the KHO raw subtree API.
>   *
> - * This interface is a contract. Any modification to the FDT structure, node
> - * properties, compatible strings, or the layout of the `__packed` serialization
> + * This interface is a contract. Any modification to the structure fields,
> + * compatible strings, or the layout of the `__packed` serialization
>   * structures defined here constitutes a breaking change. Such changes require
>   * incrementing the version number in the relevant `_COMPATIBLE` string to
>   * prevent a new kernel from misinterpreting data from an old kernel.
> @@ -23,31 +23,15 @@
>   * however, backward/forward compatibility is only guaranteed for kernels
>   * supporting the same ABI version.
>   *
> - * FDT Structure Overview:
> + * KHO Structure Overview:
>   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
> - *   This entry contains an FDT with the following layout:
> - *
> - *   .. code-block:: none
> - *
> - *     / {
> - *         compatible = "luo-v2";
> - *         luo-abi-header = <phys_addr_of_luo_ser>;
> - *     };
> - *
> - * Main LUO Node (/):
> - *
> - *   - compatible: "luo-v2"
> - *     Identifies the overall LUO ABI version.
> - *   - luo-abi-header: u64
> - *     The physical address of `struct luo_ser`.
> + *   This entry contains the `struct luo_ser` structure.
>   *
>   * Serialization Structures:
> - *   The FDT properties point to memory regions containing arrays of simple,
> - *   `__packed` structures. These structures contain the actual preserved state.
> - *
>   *   - struct luo_ser:
>   *     The central ABI structure that contains the overall state of the LUO.
> - *     It includes the liveupdate-number and pointers to sessions and FLBs.
> + *     It includes the compatibility string, the liveupdate-number, and pointers
> + *     to sessions and FLBs.
>   *
>   *   - struct luo_session_header_ser:
>   *     Header for the session array. Contains the total page count of the
> @@ -78,26 +62,27 @@
>  #ifndef _LINUX_KHO_ABI_LUO_H
>  #define _LINUX_KHO_ABI_LUO_H
>  
> +#include <linux/align.h>
>  #include <uapi/linux/liveupdate.h>
>  
>  /*
> - * The LUO FDT hooks all LUO state for sessions, fds, etc.
> + * The LUO state is registered under this KHO entry name.
>   */
> -#define LUO_FDT_SIZE		PAGE_SIZE
> -#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
> -#define LUO_FDT_COMPATIBLE	"luo-v2"
> -#define LUO_FDT_ABI_HEADER	"luo-abi-header"
> +#define LUO_KHO_ENTRY_NAME	"LUO"
> +#define LUO_ABI_COMPATIBLE	"luo-v3"
> +#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
>  
>  /**
>   * struct luo_ser - Centralized LUO ABI header.
> + * @compatible:     Compatibility string identifying the LUO ABI version.
>   * @liveupdate_num: A counter tracking the number of successful live updates.
>   * @sessions_pa:    Physical address of the first session block header.
>   * @flbs_pa:        Physical address of the FLB header.
>   *
> - * This structure is the root of all preserved LUO state. It is pointed to by
> - * the "luo-abi-header" property in the LUO FDT.
> + * This structure is the root of all preserved LUO state.
>   */
>  struct luo_ser {
> +	char compatible[LUO_ABI_COMPAT_LEN];
>  	u64 liveupdate_num;
>  	u64 sessions_pa;
>  	u64 flbs_pa;
> @@ -111,7 +96,7 @@ struct luo_ser {
>   * @data:        Private data
>   * @token:       User provided token for this file
>   *
> - * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
> + * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_file_ser {
>  	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> @@ -142,7 +127,7 @@ struct luo_file_set_ser {
>   * physical memory preserved across the kexec. It provides the necessary
>   * metadata to interpret the array of session entries that follow.
>   *
> - * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
> + * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_session_header_ser {
>  	u64 count;
> @@ -159,7 +144,7 @@ struct luo_session_header_ser {
>   * session) is created and passed to the new kernel, allowing it to reconstruct
>   * the session context.
>   *
> - * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
> + * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_session_ser {
>  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> @@ -180,7 +165,7 @@ struct luo_session_ser {
>   * This structure is located at the physical address specified by the
>   * flbs_pa in luo_ser.
>   *
> - * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
> + * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_flb_header_ser {
>  	u64 pgcnt;
> @@ -202,7 +187,7 @@ struct luo_flb_header_ser {
>   * passed to the new kernel. Each entry allows the LUO core to restore one
>   * global, shared object.
>   *
> - * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
> + * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_flb_ser {
>  	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index fbc18c5f4230..e261a03a1b47 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -50,7 +50,6 @@
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/luo.h>
>  #include <linux/kobject.h>
> -#include <linux/libfdt.h>
>  #include <linux/liveupdate.h>
>  #include <linux/miscdevice.h>
>  #include <linux/mm.h>
> @@ -63,8 +62,7 @@
>  
>  static struct {
>  	bool enabled;
> -	void *fdt_out;
> -	void *fdt_in;
> +	struct luo_ser *luo_ser_out;
>  	u64 liveupdate_num;
>  } luo_global;
>  
> @@ -81,11 +79,10 @@ early_param("liveupdate", early_liveupdate_param);
>  
>  static int __init luo_early_startup(void)
>  {
> +	phys_addr_t luo_ser_phys;
>  	struct luo_ser *luo_ser;
> -	int err, header_size;
> -	phys_addr_t fdt_phys;
> -	const void *ptr;
> -	u64 luo_ser_pa;
> +	size_t len;
> +	int err;
>  
>  	if (!kho_is_enabled()) {
>  		if (liveupdate_enabled())
> @@ -94,40 +91,29 @@ static int __init luo_early_startup(void)
>  		return 0;
>  	}
>  
> -	/* Retrieve LUO subtree, and verify its format. */
> -	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
> +	/* Retrieve LUO state from KHO. */
> +	err = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &luo_ser_phys, &len);
>  	if (err) {
>  		if (err != -ENOENT) {
> -			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
> -			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
> +			pr_err("failed to retrieve LUO state '%s' from KHO: %pe\n",
> +			       LUO_KHO_ENTRY_NAME, ERR_PTR(err));
>  			return err;
>  		}
>  
>  		return 0;
>  	}
>  
> -	luo_global.fdt_in = phys_to_virt(fdt_phys);
> -	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
> -					LUO_FDT_COMPATIBLE);
> -	if (err) {
> -		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
> -		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
> -
> +	if (len < sizeof(*luo_ser)) {
> +		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
>  		return -EINVAL;
>  	}
>  
> -	header_size = 0;
> -	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
> -	if (!ptr || header_size != sizeof(u64)) {
> -		pr_err("Unable to get ABI header '%s' [%d]\n",
> -		       LUO_FDT_ABI_HEADER, header_size);
> -
> +	luo_ser = phys_to_virt(luo_ser_phys);
> +	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
> +		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
>  		return -EINVAL;
>  	}
>  
> -	luo_ser_pa = get_unaligned((u64 *)ptr);
> -	luo_ser = phys_to_virt(luo_ser_pa);
> -
>  	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>  	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>  		luo_global.liveupdate_num);
> @@ -160,37 +146,20 @@ static int __init liveupdate_early_init(void)
>  }
>  early_initcall(liveupdate_early_init);
>  
> -/* Called during boot to create outgoing LUO fdt tree */
> -static int __init luo_fdt_setup(void)
> +/* Called during boot to create outgoing LUO state */
> +static int __init luo_state_setup(void)
>  {
>  	struct luo_ser *luo_ser;
> -	u64 luo_ser_pa;
> -	void *fdt_out;
>  	int err;
>  
> -	fdt_out = kho_alloc_preserve(LUO_FDT_SIZE);
> -	if (IS_ERR(fdt_out)) {
> -		pr_err("failed to allocate/preserve FDT memory\n");
> -		return PTR_ERR(fdt_out);
> -	}
> -
>  	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
>  	if (IS_ERR(luo_ser)) {
> -		err = PTR_ERR(luo_ser);
> -		goto exit_free_fdt;
> +		pr_err("failed to allocate/preserve LUO state memory\n");
> +		return PTR_ERR(luo_ser);
>  	}
> -	luo_ser_pa = virt_to_phys(luo_ser);
> -
> -	err = fdt_create(fdt_out, LUO_FDT_SIZE);
> -	err |= fdt_finish_reservemap(fdt_out);
> -	err |= fdt_begin_node(fdt_out, "");
> -	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
> -	err |= fdt_property(fdt_out, LUO_FDT_ABI_HEADER, &luo_ser_pa,
> -			    sizeof(luo_ser_pa));
> -	err |= fdt_end_node(fdt_out);
> -	err |= fdt_finish(fdt_out);
> -	if (err)
> -		goto exit_free_luo_ser;
> +
> +	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
> +	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
>  
>  	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
>  	if (err)
> @@ -200,21 +169,17 @@ static int __init luo_fdt_setup(void)
>  	if (err)
>  		goto exit_free_luo_ser;
>  
> -	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
> -
> -	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
> -			      fdt_totalsize(fdt_out));
> +	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, luo_ser, sizeof(*luo_ser));
>  	if (err)
>  		goto exit_free_luo_ser;
> -	luo_global.fdt_out = fdt_out;
> +
> +	luo_global.luo_ser_out = luo_ser;
>  
>  	return 0;
>  
>  exit_free_luo_ser:
>  	kho_unpreserve_free(luo_ser);
> -exit_free_fdt:
> -	kho_unpreserve_free(fdt_out);
> -	pr_err("failed to prepare LUO FDT: %d\n", err);
> +	pr_err("failed to prepare LUO state: %d\n", err);
>  
>  	return err;
>  }
> @@ -230,7 +195,7 @@ static int __init luo_late_startup(void)
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> -	err = luo_fdt_setup();
> +	err = luo_state_setup();
>  	if (err)
>  		luo_global.enabled = false;
>

-- 
Sincerely yours,
Mike.


