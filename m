Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9591CD6E5E
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 13:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88756B0143; Sun, 31 May 2026 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12996B0144; Sun, 31 May 2026 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3886B0145; Sun, 31 May 2026 09:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A179A6B0143
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:44:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41C224049F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:44:42 +0000 (UTC)
X-FDA: 84827835204.16.1E218C1
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5EE5320004
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:44:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KQcaZvB3;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780235080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYu5Y/r+ogUS9B53/mwnMY8XGF0lJLFrksh7/o5BdSs=;
	b=uesSU+PpxN1xkTwZtfPNfR4sx4KFj7jtl8ds4A1w7EXVhpOLMbpEeDkLHUR+8qQll2P5KY
	FBOohr9GxB+Yg8IDeQTMahtyo6kWzRxB4LHyJbT8htByeIyVZRzDYHhWNdYnMePM17Rz7O
	by52MDRa3zL2F2j5GjqM+XH1EymjXAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780235080; a=rsa-sha256;
	cv=none;
	b=b7HH+W4I9uL9COLBfbHjenSGQtoJV2Jrm7ojJULcU3etj7OZ1U9QstorDU8056gbAArbmv
	sf0m6GIYo2ChP0pN7ksJoqdoWxWMTXcFCY1ouO6NrysNhgeTrdMiwiwIILODH+4/KE1np+
	qg9LmCZFzXZq/NjtzQo6w9rQOY0vHZY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KQcaZvB3;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-915511c2cfcso56069885a.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780235079; x=1780839879; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYu5Y/r+ogUS9B53/mwnMY8XGF0lJLFrksh7/o5BdSs=;
        b=KQcaZvB3xtAbbvvERBosd0nXDK7X8NUEbbQ8nOaE4b3Mj/UFnlBBw1DUOOO+gu8h70
         saFBzL0r5FCAYgZR4YziX1VMohyBCm7wU9ck847N13mvSTnGI2EDJERkQwIA0XIPfIr7
         MwuTdlaP5vbTVXtKl9Mfm6RPWsg2X3ZulodnPL1iHlfHW0GTNdLeqEHMCJiddYjeXlDl
         yBiCo1+q3AruMPfONL15h6j8B8bHU8/Ekdfw8j78Hj4qxUys53az8zHvmkLeyI+kY+Ji
         gkJ/w31W3/7ZGIXsJiO6cpOp3E0lfmFfbEudi7CiyrQ+Aoh6ohvGYD7ioXD4LsK/nPvW
         KGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780235079; x=1780839879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YYu5Y/r+ogUS9B53/mwnMY8XGF0lJLFrksh7/o5BdSs=;
        b=ZRkx08e73H7xQM2fcxd553XC+EvAMnbAWgbkALKFavP5TRNYXfjaEedMJgCwfpVkKZ
         5pUhmKr8+DvM/6f7BlvQVKljJug1K4ePKEspqC7DtPFhkK/sCg4UPEJ98U4RZ1B9qNwF
         pPI2fpAZOrdrZppCC13k35X42Mh6h7j//or6h/G7TywQDsztOy+M+go+GEP+Y7m/2Eqp
         UJmKhJARm9u6hah+nU9frd89gX0hq6ElzBBoAtr7lDe1SpR89fqaFkT4Q0xoQ4+loB8U
         8dSWqYV1e5JoUMijW7X9EYAnF73ZMwmmLG6DtcgVa2Xkaf5FMlI3xH98LfGWKnzEp8SY
         BJ/g==
X-Forwarded-Encrypted: i=1; AFNElJ85FWpvQ2Hj68JmQoesOxw3f4czAODEv4kuumqt9c3gJHon2vefEKKbgbmbUyUaPTOSWm32+SS8bg==@kvack.org
X-Gm-Message-State: AOJu0Yxbtx4WQcYJkhhg8Z2IWEnBSxKlm3xpk2ROmXET8H8Nmg+B6Xsi
	esv21BNXaZYmyp/d345dmm20VPa6yYYIKJUw8UsmkFBDKuUALAFhmW2fZQTicB+GNSI=
X-Gm-Gg: Acq92OGwqtVPW/WqOn4OeSKUct3UUQ0D5i6Na9DprHCBlPWXgIT7uKXx3km7A5bCrsS
	gf4R7kbg0Pi+xc19Srv+vNex7Xm8i8g43S01Yrgh9hi7IyE/N3oSZYJbb/wiYFv0VZ1me/7dE5H
	GYWE3hlw7J0GJwyOq8EYXvbkVgNePhuSEgyqD2kJ+TBpK6y6Ukhxfy7MRm0uAdtcNiv8XG3mTEb
	h1aKbavFUIP9yZuPAKIp/iurO7LCTkCRLssJARIisK4+ptum5wiUbHCuqajtCFnGwD1+X+lO0ic
	AZ0yNrdIKMv6KUVuNoeOv2Tx2ea1cU7n3mh1ba8Y20J19zjtBUfQrG3rmDWy49Qw7BZ/XoZLDZo
	t/sqkq5DNkf48685ue99dMHUh5uVCJZGc+OYevujJuIdfU/T/H9N14+FoOROFkhDFa9SewyLG8Q
	pXgzm9PN+bw27blp6Z5XHUbOXyi+qi7Xc+8+jMd9tkdR8r3zvDUgxnkb88yw6JnA==
X-Received: by 2002:a05:620a:2307:10b0:914:dbfb:6f7f with SMTP id af79cd13be357-9153da3e110mr804121485a.51.1780235079179;
        Sun, 31 May 2026 06:44:39 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153244ad25sm750256085a.3.2026.05.31.06.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:44:38 -0700 (PDT)
Date: Sun, 31 May 2026 13:44:36 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
	pasha.tatashin@soleen.com, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com, roman.gushchin@linux.dev
Subject: Re: [PATCH v4 04/13] liveupdate: register luo_ser as KHO subtree
Message-ID: <ahw6Bqllb0CJ88mR@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530221938.115978-5-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 8sqix7gf9rndy4cj75qnzkky16o5bspp
X-Rspamd-Queue-Id: 5EE5320004
X-Rspam-User: 
X-HE-Tag: 1780235080-795657
X-HE-Meta: U2FsdGVkX19o6dnV/P49L9vKN/hOC1kSrYLpDvEfkZOvAjURwmniNmg88hBLMBCWu6yHeeLTQgZrWYr+Nga9cPYTU86E6vLjtw+uFahH/utPNiTuYZRTUyUqP0M4CoCC3y9g6fa0IySQn4Fbpg2TYpopo5cOq0X1S+EklRQQXSbzCXWRtIuYt/HPpqU7d7TZHeCSwKA6xgit4VhwwpeII02nvUX6FRozPBND/XLyHndGkEDojmoP4Bkr/yClQDBFvVS7ugw0M/2yHtCPM5rYw3wsOL504QszpVBlJ2V6bxWZOqR+DfN8jEOHQyQJN7OkVlPbCEGcG/tuOHXCklAX6helMtSp1GW1ogu2EWB9xsF9Z4KG5RDLQXWSFPx72I0hQwuQfqvfDfjLKZGIqwsxzYzV1Fu0Ls9i7cxpCNeb/V9GhqDu+Vt2naDvAl8nb3hGa4619YcDmK6Q1qIzaMEPFuP8HfxCCzBTsnZGSyZTknB+6kT5HAjGsBRZ81CP2yn9Vo4E7VNUKizvFqHA7Hxp4UMufyBaYXReuuoxyeKuht1LOvvjMa+qcJQIyj6UYEFPPZF5X6sFgngkCBsRkEWUNoE6oYat3UwgNjjVJp5aMd9hGyli1T7FFow3XGkWIQtBsTdmQ3zbfBlNnya1/aZwQ621BQrjnJ/4Emv2vTQn5t9yzqrgHKIG6kyKN4jAFM0SuKwiyJI5YDJKjfJeuwT5HB6iverUCH/hIKcNZvgbw1ltwn5Yu5UYONHc/AwgpNdUyETTHl3RfozqGE+d8p8FocidAe8CeeUCjk5At84Bs83UQR4+RR0O4y690GALu5SzX1G2KJfpPLbDDsi7JjKL7/KHz6cw3CXNQ6YtC2Wlvu671/nSpuMNVc+tFWhGEPGdoomEDly6xhwkCM27wCRK+lZqkQEWPBkE/x6agErpK62idPzUo2iaqT6n/LS2eSsfZFs8mRJGJuDZ6WwbakR
 AndogeKV
 YY/fV20cV9obVAbSHI3DVG60KkPr2YKVnhqU5C6oklFzs0cRzCZotb+wVzmSPKg+4Gd2FXgWE1gfgknDPUcF6CReqwaA6hoExcpd//QrytrGLI6UiO+ju7iaTe14yv+c3zIpgVfUlf872Bv8/WZysiTXJQgFYAOsWGfWUoVOrQU17B8mnDFromAgQwav3JcfuDhYKEjtutLhsfkqjp2KQ8h237tuzD8op5K/nZDRreacf/zla696zZbrpWC0kr/q7i9wNXHgGsVNGybefqb3OuOjNBRgAHuKaj0YT+3usZVGR2pgvUe5oDeF/dx6C/mxmy+MW454TEINYBwtqRGw03B6L81QKoaKoh9v760uI2/d/ze6Lc3xiByXeAG+JKT/Zd8yxfJj69+gF1SS24AMSt7NQGj/wYS32MnYUoawdnalHYhBg+DwYfPOpXsnU6sHmD2DYnSjWa1R649+NzZ4mFZ5/1J0fEqciGxtYLLd7Z5+PSzs2J5xbsYoJJVWrOwHeLzrl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-30 22:19, Pasha Tatashin wrote:
> Entirely remove the LUO FDT wrapper since the FDT only carries the
> compatible string and the pointer to the centralized struct luo_ser.
> Instead, register the struct luo_ser via the KHO raw subtree
> API, placing the compatibility string inside the structure itself.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h  | 57 +++++++++---------------
>  kernel/liveupdate/luo_core.c | 85 +++++++++++-------------------------
>  2 files changed, 46 insertions(+), 96 deletions(-)
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


From Sashiko:
Does this code leak the preserved luo_ser_phys memory on these early validation
failure paths?

Answer: No, a failure in this function leads to a call to 
luo_restore_fail(), which triggers a panic.

Roman: The quality of the Sashiko review is surprisingly weak this time; 
was the model switched from 3.1 Pro to something else?

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
> -- 
> 2.53.0
> 

