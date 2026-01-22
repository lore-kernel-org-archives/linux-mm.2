Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF58AC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EF96B0130; Thu, 22 Jan 2026 04:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6C76B0131; Thu, 22 Jan 2026 04:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CDF6B0132; Thu, 22 Jan 2026 04:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC8466B0130
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:46:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43F08140141
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:46:37 +0000 (UTC)
X-FDA: 84359120034.07.B721E43
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3722D180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:46:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsrGlHN5;
	spf=pass (imf06.hostedemail.com: domain of salvatore.bonaccorso@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=salvatore.bonaccorso@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769075195;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eALT1Ba+MHNBlVAy5iNIf3AX4qDAc1KcwVERZT6e1Wo=;
	b=BTSF8tY4Qbyhd+bZRKaitYjtUV9YsHQpWO0VpLNSO6K7TO5UvlNmGR+dXLSPWKraSZ2/lf
	hExuQVdtAon3W3gU5vrcHCSdOVPGTSjzc+NQndJ3F6NRMHsPf/1ANLfG9L0JQ4fo6eTb9E
	4YFgbcR2tIUY+JiO2kcx/9sixaTsOZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769075195; a=rsa-sha256;
	cv=none;
	b=Yk2ACsmsNMqaaclQponnWIKh6LB+DIj7Ke+nH99BqkvlQa+BFDgiPqEE7Y9HeeY9EnlomV
	tEONJQSLXkKCj3U1jEXGQz24yQ69CWiZPIcqR6mR8P2xU+ZihWC6sfnjt/VaiKf+LgKT0F
	cOguSr05v6l7BClE2drtTCSY//ZXnoQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SsrGlHN5;
	spf=pass (imf06.hostedemail.com: domain of salvatore.bonaccorso@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=salvatore.bonaccorso@gmail.com;
	dmarc=none
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59dcd9b89ecso939713e87.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769075193; x=1769679993; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eALT1Ba+MHNBlVAy5iNIf3AX4qDAc1KcwVERZT6e1Wo=;
        b=SsrGlHN5VolWtM6d73gu2Hjd1TVjziAvV2iZ2aLgjZYwvCVYFJMUUvp5XpYedQRvrq
         9RieLPnGYVe6DD3MJSKNJjH57/UBhMvg8qqCX+U7puizbAaOza9mVz0L6VwmotOAfd2J
         DMH6i/txJNr6w/prQYTHFjI0ZfqjUPiSTXSK8FT34+2f3h32obmtujqi7G+gJq4hOFnO
         Zu8mLv7ylbR4BR4sngoERfdEqGa649FvFkgW5SliRUeDvvQ+fSgyTBibjxYLNO50ahyz
         ld6LXsgyAAocp0RjUHGhCXkCQroAtROHdxmljC7VPKQqw4tctCyqGcojjeDnOnMDgBxj
         1bCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769075193; x=1769679993;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eALT1Ba+MHNBlVAy5iNIf3AX4qDAc1KcwVERZT6e1Wo=;
        b=hqaqMYFIo/y5eh5q3G0g/fzbUEi0WkA+2k6LtWp4blLjXVf1Lu3A5PPm9JSCl63r5A
         varESY1MDJKIRWDRTsvQSbN844GR70lw+vTT521cd0gKknH2gicFHMu7n3Fsk3M8e9Jy
         3dNDPFXstllJUvov3PC7/h8Vtii/5i3Xo3A0fGhRLR7F/yubNfzXiqPvTissiLmyDsvN
         8KtvJhA1rn5GgenI1zclZ9oSpzDnwKLeSaPKeysdPhnJ8kCXPOftyN3wbCVa74tSMciU
         Tr6U/XVxqAlzOOy33sQjZypWGOySCOnzSu64omuC+uYVshyk1HBpLkswlx/F88k5GoxD
         6hcg==
X-Forwarded-Encrypted: i=1; AJvYcCWNXNIHMu0501u8d+EGSIkHyg03NkJkBv5VA+qsGIp8uK4aho4YVLjTbjeFoMVb4MN1YXAZ3GE9+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw3pPCiYbj5owhde/uf8Hrs/jAdLc0O4E9YCG+4Q/rJS6VwcP24
	UKiZsF9j762AUW/zmOeqLgZ592j+7PP98pDtgmU4X8nEmngPoKRkl8fEFhuGSKzs
X-Gm-Gg: AZuq6aLop343MlO5i3kFUZQFI0ihefaABFNSV/sMUIF1vAe93coj7ELzu59vVkSJcwJ
	ArBFV2TpGPnlrW9FiVMP5qYmSZGL8DOuZgGPBKRgyD7wPZ4QjMlvBPtlWaVsl2JHEtmpRTO3vgp
	gWjOLu+6FiwkA4IVhbkMRioui3eDcMEd1WAgAOgwhql0eSp5qzftakGaO8V6CqTz1CfBsVQHusy
	7iYw8yYXsYucyWCI8Vx1dmtJOVpV4GtKi6bD1ZblWJ2xkbcZaOWKtC2RPiBUVwK7ENr46Hj0BKC
	V44vY6SO8pa3TX9DNTFsLGZ/nvRWc3uuFVB/gaEXClz0iLzLe+AhhJbajBSyI8c/xt8a63s1ol5
	wHMLzsRIx7udsNdDF/SJoFiflapSH+SPBH6XYbVrETLs/96iloqEpl7CAHgwNVqU4FXpmL3BP3F
	jZD7VfXBTm5x0ktpdL/257sJdW60Of8QpWZMijyQAK0ylS
X-Received: by 2002:a5d:64c4:0:b0:435:9144:13fe with SMTP id ffacd0b85a97d-435a5ff8c0fmr3688943f8f.26.1769070126382;
        Thu, 22 Jan 2026 00:22:06 -0800 (PST)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435924ae723sm16436873f8f.41.2026.01.22.00.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 00:22:05 -0800 (PST)
Received: by eldamar.lan (Postfix, from userid 1000)
	id 63C17BE2EE7; Thu, 22 Jan 2026 09:22:04 +0100 (CET)
Date: Thu, 22 Jan 2026 09:22:04 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	regressions@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Giuseppe Sacco <eppesuig@debian.org>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
Message-ID: <aXHeLGr1n-W-Ay44@eldamar.lan>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
 <aVgjpWaIRkerdgCa@eldamar.lan>
 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
 <aVj-mz8vaw53TWtX@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aVj-mz8vaw53TWtX@debian>
X-Rspamd-Queue-Id: 3722D180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 48p38g4h8c6id837syydfteoghaut73i
X-HE-Tag: 1769075194-342875
X-HE-Meta: U2FsdGVkX1+DolC9+jQgt1MxAfHrr11DYAhRjUoGmPq65ne0zSbDvpMD8RRiCRsQ/5027HB3tGCutAoYO+TqKyizotn8pVvxMNEpM2PJsYk7vsyBqIUtkQY0SivzvjbP0TUpwt7XyyZECv8VgHxKm93rqCH1oVnGUVgm3CKO2Y1pI0z/2FmhVmlWhebWEHIss/aJrpuBzn8wJfrWzhL2OXtcAYhCcsliDJz7k5jSJV/sgm+M9H/apKWAdvPHVQq0LOXpl+8i/QYHhRpveD2h9bQu87jlFDl4kKFA/Fbuv6INdYXtsjjd3/ihMQzPHg36ERkRok0jaUXVLgbkfizXyLz6zzfvHdra2zJIXcNbNuCny7WVV3UM+OBT/j0Y4nna/NBtnfGPVfEiEiHyvRVnK7hsQQ1mCPULQqh5o0yss9gi20XgTqRQmHbfc1nsF0Kv1eTNTWGQcY5weJANt9essj0kLCtagDILV1QrypFXgyH6e21ZJLH/6cv1YTRvk9ReJrJ1lO5IelC9oaLZeJ1kmtpFoH/kbVu9jACS269wXF0n6zxrQv0jmuvm5gpTz8B7M9m4hB4JFbkUgDhsiv+kQg1f+pnDtPpDpil5Ji0brtXU1wmpcicoXV722fURsjQnuPRIb9fce15ZrnUk5CK2DZsjEln2wJZOL41ylEGFdhPHtrlfmGAV6214X6q4AvhBPjETFVrce24h4hDEIVnFG/9U1Ilw4jxJlRkCHJ6ZAVjFy1Fl46b1lY9h7Vt+UhGONuYhJuWSqxx+qMO+siIK1NWKNpnydit/7sVrR6eAJthATupXZN4IIDwuLVS+j+G2G5/2wHWfz723imnpoJI8/AqMh6rcJuPTkJ3cnaGgXN0XOtED4g3b5vPMRgslCdHl0uy+q0fFdWOBzTYsjRg18+YMSnB3HL88RadsUQVkX96HCqTGIV1mI5aOtd6ARtNCQNwo0fA1EHLSQ++tbTz
 o0pYqqFB
 qSNx4p9v+jdPy7gXoa20+6MnF4dVuhbrOXJeZeCyW9ltvEZuHl2tfUlNCnrU4LIYcGEs+chBNBY41/B0BwDP+XlOank1zH04fukbPXLRleNShgnHQMiMWcfbnS1GRbf0brl+aTvVnNAmQeRorKKI3n/aM3e0RSlhYmrZnXrIyunWQVC5C3dgpz4fofXfXKSXxiaBywgfEC5eCL05XudweZ3jZm4z9N2zQl0fgUVSQGdFvDqPNe6d6wqupkAgLOClPiMIGewiebFOJ3+fl5TIFw29JQdVLrDU1Al8/u8cicQ1fd1xdDdCZmIGrLZjWIHPb0kjDvC+vPBliJv4VbC94maJ95WejsKebZV0hvs+23tBYSEa0FzM5MPUilN+Yli0PQOxA4x1SWCWqHAXXi+MrVwY7njb5J9IoraTqe8sD/OmcWp+iYB+vbEWuLDz8SwNBtezYyJpgtpHCMW65eCfxMI274tdtl6s7UCgtTYqJCiYNp4BvgELhFIXNR0SrZoAmbSQdl7OEd1NRbfrTGhgCNJLvZDV5Zm/hh4W2JrLv1NJs7fK8eYZPakheJR4Y6Xjd3bBkS/t6A1113iJHG8rRiCpPGsy4ebNBy/DVj4gqvotLI+Xj54AUwk7wcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sudip,

On Sat, Jan 03, 2026 at 11:33:47AM +0000, Sudip Mukherjee wrote:
> On Sat, Jan 03, 2026 at 12:01:19PM +0600, Paul Menzel wrote:
> > Dear Salvatore,
> > 
> > 
> > Thank you for the follow-up.
> > 
> > Am 03.01.26 um 01:59 schrieb Salvatore Bonaccorso:
> > 
> > > On Mon, Dec 01, 2025 at 05:05:59PM +0100, Paul Menzel wrote:
> > 
> > > > Am 01.12.25 um 14:25 schrieb Sudip Mukherjee:
> > > > > On Thu, 27 Nov 2025 at 22:55, Paul Menzel wrote:
> > > > 
> > > > > > Am 27.11.25 um 19:51 schrieb Paul Menzel:
> > > > > > 
> > > > > > > Unfortunately, not reproducible, but starting with Linux 6.18-rc7, I got
> > > > > > > the oops below *once*:
> 
> <snip>
> 
> > > 
> > > https://bugs.debian.org/1124075
> > 
> > This is
> > 
> > AMD AM5 ASUS ROG STRIX B650-A GAMING WIFI, BIOS 3067 12/10/2024
> > 
> > > https://bugs.debian.org/1124463
> > 
> > This is
> > 
> > Dell Latitude E5470/0VHKV0, BIOS 1.34.3 11/20/2022
> > 
> > > Does it make a difference to cold-boot or reboot into the system?
> > 
> > I only did cold boots, and I am not able to reproduce it anymore, and wrote
> > it off to some hardware issue – despite the system working fine otherwise.
> > 
> > I am adding the x86 folks, and regression lists.
> 
> Thanks Salvatore for the Debian bug links.
> 
> I had been trying to reproduce this but have not seen it on my machine so far.
> 
> But looking at the traces from the Debian bugs and the trace from Paul, my best
> guess is that its happening because the low level driver, parport_pc in these
> cases, has not completed setting up the hardware.
> 
> When 'lp' starts registering, parport driver will check if there is any port,
> if no ports are found then it will try to load the low level module.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/parport/share.c?h=v6.19-rc3#n198
> 
> As mentioned in the comment request_module() is not trying to load a real module
> and it depends on the alias. Also, mentioned in the Documentation.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/parport.rst?h=v6.19-rc3#n45
> 
> I am not sure why the problem is seen now, but is it possible to test the
> below diff please and see if that fixes the issue.
> 
> diff --git a/drivers/parport/share.c b/drivers/parport/share.c
> index 427abdf3c4c4a..8f45daf7b3825 100644
> --- a/drivers/parport/share.c
> +++ b/drivers/parport/share.c
> @@ -287,8 +287,16 @@ int __parport_register_driver(struct parport_driver *drv, struct module *owner,
>          */
>         ret = bus_for_each_dev(&parport_bus_type, NULL, NULL,
>                                port_detect);
> -       if (!ret)
> +
> +       /* Return if no port has been found. The driver has been
> +        * registered, so whenever a new port registers
> +        * attach_driver_chain() will be called which will then check
> +        * all registered drivers.
> +        */
> +       if (!ret) {
>                 get_lowlevel_driver();
> +               return 0;
> +       }
>  
>         mutex_lock(&registration_lock);
>         if (drv->match_port)

We had another report (https://bugs.debian.org/1126128_ but the
problem remains here as well the reproducibilty. Uppon several reboots
only the first one so far showed the problem and was not reproducible
afterwards.

Regards,
Salvatore

