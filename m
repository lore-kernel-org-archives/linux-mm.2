Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42774FA374B
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DAA6B0088; Fri,  2 Jan 2026 10:25:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C14A6B0089; Fri,  2 Jan 2026 10:25:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD136B008A; Fri,  2 Jan 2026 10:25:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58BBE6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:25:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4343140478
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:25:10 +0000 (UTC)
X-FDA: 84287397180.03.D5E793B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ECEE100004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:25:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="l/OMdVwo"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767367509; a=rsa-sha256;
	cv=none;
	b=tVPpvWxC+BCu7JjdNjEyCjY/kARRBffIqOO408RR9SGjsD7oyUj1ijaQBIbWfhSiLXLa+5
	yhzYsXwvZitMzFKvykLfofe874VxDMHXjPqRsf8fTY4lEAaSUGvK8mc4I+iCST8i1cKu5V
	oX/cGIRfhuUEvuqhh1Kn7WjPxTelF6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="l/OMdVwo";
	dmarc=none;
	spf=none (imf05.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767367509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ATmRLVIj/dpSXHUu80wsY1AVHwJ4XogjTeSd2UkX7s=;
	b=DDUPYq98WAcjMS/wYxLwDIYUmYQCvBnLEh9kKyPaqbvsbi+eUqeX6TbJAyI8WtsPHRr6g3
	oRCgxxCAHW2HGEg/XxNAHn9HUIfqDB/dLpW0lqkGrYRpPRG03kGC63kO6e8sXcv/LPoo5W
	gM6RBgsoLtYNB5GPRf4+x6G6XhfHOZQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1ATmRLVIj/dpSXHUu80wsY1AVHwJ4XogjTeSd2UkX7s=; b=l/OMdVwoP+BxOw1FOfUKX3TA5W
	QaELsyT2G/o3l6sMPMOERj2dhDRAJU7Ec1Jh9/IUCL773sHbQaBtBhZ5BohCMgjp8mQ6z7x2tBfbe
	Tq7hKc1pHtdMYUKOp9TmfZGKUtG9Us0u7J9s65YxYI+hl8jyyAoCMOTi+aNz+JFrcN5E3qTA5U2TA
	4rbQyGXsJ17c87O4480y5+Rz/6sc0gI3ifbAghxE+P3mHNDq1bWx+EI0v/FdXvvDfXeRu6ybzsovt
	rf74/P8eciKRjNWmv+szLL4vYhsEWiDN8EHPrNpcc0sg1VEEZ71TUzpWi09pCy7Rewkft9VFumI8e
	Lz6XOk/g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vbh1P-00EXyd-2g; Fri, 02 Jan 2026 15:24:59 +0000
Date: Fri, 2 Jan 2026 07:24:54 -0800
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, rmikey@meta.com, 
	clm@fb.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
Message-ID: <rsygqnm3qahkfoqo6usrz3jhpya3c3rqebz6rotl33dsx3rsbo@2v4yeabi7fda>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
 <fc542a5e-db54-4d7e-b363-42cc253b1a8c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc542a5e-db54-4d7e-b363-42cc253b1a8c@gmail.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2ECEE100004
X-Stat-Signature: jgeku4mbebanqaydjghq15zohrp4z8n9
X-HE-Tag: 1767367508-576404
X-HE-Meta: U2FsdGVkX1+p/YI8KxfOjC2B27gZ6wdQozLZ+/eE5GAP9qISya17zpoaM15C/jEW4TS7AvvcfVZCLRTCVEkaS7uL8nyAnuw+4c/3IPTZ1i/YEgi3MmriAMGWY9ioS3AWaoJthyr8g/Cu2P2fgNMdE0bs+XWCxeH8HVZbYwpLgP5dOrzHfyQN8eaRIjKk9NKMaLPR5QAkwPUNBCcHTqIgXZvR7q/6sVVZSfqzKFi7GTyX1dI2yIWCvx6IZ3T3fOR7Z629D/9H8m7nhbI8gmf/xgCqMd7wQeAjXuk9k4/i8VJb4DJCgmKkUEcGuWTnpGbsRzMqKqJd1N00a9RMIwxZbXSCVDt3cnGF1KZNS47Z0QzBcbSuX+jlvlPDu53OUoCldaLtWcq7wUd7S3gn3QoI4SagHqVPfel2pH9DzRLVqBjBsuj5nYfWuveXcaALKipgx9DkbUbdhTfrsmnQI3sGe62/ZbEvoF2G1GIqvAnDt2JG8Uixr880HIrdkrfK1eO7pDfF7XFLuYmm81CDWxVG0/bEPPKDjHlJnK968c6Sx/6B1B5IHAxDLzwsyUVXq+2okUKexz3ri0BungbztEHTs1JcEWAAb91WIahIyb4XfucvPDK/j/+/TkdfSgzGYlHg0SaCI9DMbgi2q4kBgyxAdQBGsolyd5CLardbjFv/Fg1bpo9SBAshs49b3u+eibQbs2BXUcsyhMbOc78xxP6g03fnt9epazUPS4tHMUdinSsnFVXji9fvHQ2WiUiJWZp5BZwXDYAAB0Ix3HVJnjYlPqk95YkEgNfAPQaYZ+f/TQS4HCdobcV83ZLP7QPMvX9EDHF1aPE5UHmycIirFYlYcTcMzb0szLJPulRB+vhRlBsw+Z0cCP88ncqBrtxADmc/Sw7uHOpH0IlNlqgdiOxoaYUb9xNjEWMH9WY9Ixvjz5ZcpW8ZYfLdxls9HAJ6RozC8D0js+hZdvviuBDJD4M
 Xka1Cslj
 g2TV8/NSzi2CPlF+q2N+IEWfcO0Wyg3EAEbyLzqd5w+BAsSOW6dLsuf3d2oEmoUtQV94CEjg+Gi+nM67yr+8Tx0TpPBlxjlV78Jn8Z+rbv1CKfvi28+FP3nhJZpASVD6d30/+VsHBO7XN6RbwXIR8Ktj/vtsYPmBY22Vm/46yD2ivKmJvSjNvEKmYF+P8QhpVdcq8FLN1LhuzimN3Vut6/8b6ehZqsx2MorMT5At1PR/ab4FsvyrRgIIM4iDDM4mh4U8z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Usama,

On Fri, Jan 02, 2026 at 06:09:57PM +0300, Usama Arif wrote:
> 
> On 02/01/2026 17:53, Breno Leitao wrote:
> > Track and display the number of kexec boots since the last cold reboot
> > when CONFIG_KEXEC_HISTORY is enabled.
> > 
> > This extends the previous kernel release tracking feature by adding
> > a counter that increments with each kexec boot. The counter provides
> > visibility into the kexec chain depth, which is useful for understanding
> > boot history in production environments.
> > 
> > Add a new property, "kexec-count" in KHO FDT alongside the existing
> > "previous-release" property. The counter is:
> > 
> >  - Initialized to 0 when kho_in is instantiated.
> >  - Incremented by 1 on each subsequent kexec.
> >  - Printed alongside the previous kernel release version.
> > 
> > The counter is stored as a 32-bit unsigned integer in FDT format and is
> > only active when CONFIG_KEXEC_HISTORY is enabled.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 06d99627bb3c..fe5a2c5c4c86 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -38,6 +38,7 @@
> >  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
> >  #define PROP_SUB_FDT "fdt"
> >  #define PROP_PREVIOUS_RELEASE "previous-release"
> > +#define PROP_KEXEC_COUNT "kexec-count"
> >  
> >  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
> >  
> > @@ -1257,6 +1258,7 @@ struct kho_in {
> >  	phys_addr_t scratch_phys;
> >  #ifdef CONFIG_KEXEC_HISTORY
> >  	char previous_release[__NEW_UTS_LEN + 1];
> > +	u32 kexec_count;
> >  #endif
> >  	struct kho_debugfs dbg;
> >  };
> > @@ -1330,6 +1332,9 @@ static __init int kho_out_fdt_setup(void)
> >  	void *root = kho_out.fdt;
> >  	u64 empty_mem_map = 0;
> >  	int err;
> > +#ifdef CONFIG_KEXEC_HISTORY
> > +	u32 kexec_count;
> > +#endif
> >  
> >  	err = fdt_create(root, PAGE_SIZE);
> >  	err |= fdt_finish_reservemap(root);
> > @@ -1340,6 +1345,10 @@ static __init int kho_out_fdt_setup(void)
> >  #ifdef CONFIG_KEXEC_HISTORY
> >  	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
> >  				   init_uts_ns.name.release);
> > +	/* kho_in.kexec_count is set to 0 on cold boot */
> > +	kexec_count = cpu_to_fdt32(kho_in.kexec_count + 1);
> 
> Should this be kexec_count = cpu_to_fdt32(kho_in.kexec_count) + 1; ?

I don't think so. Basically we want to increment the counter in native
endianess and then convert to the Big Endian (FDT/DT are big endian
AFAIK) and then store (line below) to the DT.

If we convert to big endian and then sum 1, it will mess with the
result. 

> +    err |= fdt_property(root, PROP_KEXEC_COUNT, &kexec_count,
> > +                sizeof(kexec_count));

Thanks for the review,
--breno

