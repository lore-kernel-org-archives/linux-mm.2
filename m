Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C708EE6432
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 13:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012F06B0088; Wed, 31 Dec 2025 08:16:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02CA6B0089; Wed, 31 Dec 2025 08:16:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7B96B008A; Wed, 31 Dec 2025 08:16:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C74546B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 08:16:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26D695D4D3
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:16:13 +0000 (UTC)
X-FDA: 84279814626.28.71EC870
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 85B1040010
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:16:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FdAEpBzq;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767186971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajz8Fd6mcoNmw+/d2cyXO5AEu5YjYnv2PPa+YT7Zvjo=;
	b=cfqIJQmqtZkDWM3DOVPoX3egt/nOY/Kj9E3I/jLJvCCmg4VvL8vj1yMVHHicGMT3EmBhBm
	ZCBYeEbczXMTlQioGTgSdnYPE9R5mMDHpbSsVq5H1uKRBkyA4uzxthSTG322j18KvvbJeP
	92gwUjvsPLgwuHM1SFaA2Nv0zpa5k/o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FdAEpBzq;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767186971; a=rsa-sha256;
	cv=none;
	b=vGqtnBeHEiPdAWZybbCufM0ThrIASbXHsdTDp9O/SYGsVjTHveps7QWJNIVt2piWrZObP7
	9rFuzLJaTkgUd3fap4GL+zsD2QZWlr2habAUKsWROFl8k8xXd+VXK42LXCJAQLrmaiB2Oa
	5MST7lVRvbT2nWaigVdvP7hXyvWdeMA=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0B67940E0173;
	Wed, 31 Dec 2025 13:16:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LDoAWs3CqQvW; Wed, 31 Dec 2025 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767186957; bh=ajz8Fd6mcoNmw+/d2cyXO5AEu5YjYnv2PPa+YT7Zvjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FdAEpBzqldA0FeXm7sNHVBuhVYJiTvPHL8qp3YgFIMdyNKrUM7E3jDKeP66qBGdiQ
	 jAauXPQde7d9O7MyizDlzj+ko9TLoc6hHle7MfG+0ycz/cPN9PtrOqpCnjalh8vdoC
	 VFRkDyxO0vbMBllQseNvc1I3BnqipkkG6k2h4g4VHE6CkXW2Al5mgu5sXPX0LSUXEN
	 +01IR9nbFwYgR+2LWiYOQW3CPtwu6YbyubvSPl2NU6qazF9Jc20+R2Ww4L+xflXVwO
	 4d4H8eK5DHGFMmX+UJMBP3VvgbePoIC4Wuo3RLDyNT81j3SZE2DMnM26NFtJDUGwKF
	 6/lgoRUDLfr7z/FZ/dBRtja5JedYEhKUCiC9zJDAZDKN8sBwrzhukKffzSvWuD7Df8
	 wzgnpHTQ6DyloW7kqRDoowGjtsfhQrJnwlOUjm73dsYvi5fyLlGPGfU9JUMQ8xyzLP
	 RFsVC1jiRTk3ygwQYZ56qnOaW658K7DaCaa2CGvtfONexV0i7bZO44yT7Oi1ZOjwx3
	 hg51W1GBPtafHotFEqNZ0TN/Co8lYGQYYUwjpYKFkd6twLzs5PZ9P7D9x9/71t0jH3
	 DNEMa35/AcIzGoIJsLcmx+QOrSecqmsXtCatFmNVaICo0ujuxcQ3xpmFB2/UgnFJQ9
	 0fkXBj7biGgyxIfe5fnivkXU=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2077240E01A9;
	Wed, 31 Dec 2025 13:15:21 +0000 (UTC)
Date: Wed, 31 Dec 2025 14:15:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: "rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v13 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local>
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-2-shiju.jose@huawei.com>
 <20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local>
 <fd4e4419b6d54c69bb4a1dde0273ee51@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fd4e4419b6d54c69bb4a1dde0273ee51@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85B1040010
X-Stat-Signature: q1gmrzn69r4u8m5pk5aonzcannx5mh79
X-HE-Tag: 1767186970-88990
X-HE-Meta: U2FsdGVkX19rwb1p4EhMMmkPu9AMJOWq+6np3OPCIhJ9cqYwcuR+bn/IYXKAB3G8qnJvgf0xzguepB2Dp9uO2PzYVV3pJr+WwGUwAxZ9+BJ3RVSTUfvmLsA6vbbKpwGVTkRwGVgBGrdrdUnkigu0CfP1vqewdN7CBwNMJunPYh0+n3Kzz+Ue4P8WfegmDE8efG8B+FDotmDXmu5aAndmyUdomzJmlYsrCAwk5nrm6dUO2UgBHr+703fnYAy7RFx9twWY1I/eM4eOWCE7uA31vgaYaovM0Iyr7Cics+VdmwMsDeNFwzxn0+4CS/Oz3qpL0MNODaJGoBSB0qyReA7ZU7TWCfjgBtQR10UI00u6Izllq7HWFe0D8QkIWtRW27AcZfdoH9GZWAERTBKHvrL7NacmNqIjAM6cweYBjzzdP/8Zx+kLcp5yrJ+syQ/Jizbm0bPTg5nuZJP1FWbFkqWGMLao6/MaGUf+CUEUg3pNqVcDA+1d/t/PyKrZ9x5QbnQsbEYfkXgPB34dq3dlk+0/QuI5YzobniI7uZPVCHoDBghvVEFMiKRcDLwMlGMUztujEDToZxjfJGlda24cU2Zc0gnv3dSWWvLWam8nmKp1uInpezHWPvdjq9YTk07r5c91k41qtlGWCfy5jPaa9bDz7zwV5BzsCaIaiVcdSJTh6z0m3o98DKmGU0lUzvZLnGGqyh8k8oEkMQ68vbkvxpquXignffmqBblOFcwUv+Lo9FlBr8AH5a7EUUR+Tk0Y2Qrq2hSP/mbFYo12PWpJVevUDggHsmjcpd2lkam21ph0SFK08B/utxn42uhvOmhE6w1oyb7vxekVvDgkpKtZTaZcXjfWzIUbCTyHKQ1XWKjEMaL22wUApb5OGTbrZkxGmyPyP7cERaWqvEyvJQnTlnBd+ZXC3mQniIKDtxJJ+wxWbvMRzcR/ODjgMHcmFlQK5GbWh5f1/NlWl5IyTVFYBe9
 2rAfjFx7
 a9l8BPtwwZM44p7DyC/2vM8dEDOm9ql4OP+heAgiRUcXkfeRMKxk7NlUen+ZCeurMkEJuTAFqgBZ3Jto63w77bCqw4EO5K56yiByt27VEa0MGPecssUEQr1zS3CvPj4sTeGcKQ9zMRNRYaThKj5z/0Pu9KTol6EGQ4hudOC5jPl32RFZp+oNktX2C3uXxlHoQcgsnj2Ji0rBzhhyd5Q5+dDHOW3Q48eoPyoaAKQObT/Kn1zDjFQoJi4zSKOhrV9J8ZmXlQLj4+hFbaqBU31VNHs0E++Zm6szEy5bZfHO4a+xVE3JCHRibZzkKdbr8ZIJ7F3yUSMXwTfBszkqgnibv8yZj1mmDVGrCXefhDf1+a0Xgap2a4lqmjHXaUZ8HHX7qwl0Qily6zZtK4Bt2sOsMv0FW4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 01:28:19PM +0000, Shiju Jose wrote:
> I will change to depends. I followed the existing CONFIG ACPI_CPPC_LIB. 

Read the "Note:" under 

"- reverse dependencies: "select" <symbol> ["if" <expr>]"

here pls: Documentation/kbuild/kconfig-language.rst

Now, some of the Kconfig symbols:

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 2322b0470d07..7f846c22fc30 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -295,7 +295,7 @@ config ACPI_CPPC_LIB
 
 config ACPI_RAS2
        bool "ACPI RAS2 driver"
-       depends on AUXILIARY_BUS
+       select AUXILIARY_BUS
        depends on MAILBOX
        depends on PCC
        help
diff --git a/drivers/ras/Kconfig b/drivers/ras/Kconfig
index dfc3a899280e..a1e6aed8bcc8 100644
--- a/drivers/ras/Kconfig
+++ b/drivers/ras/Kconfig
@@ -51,7 +51,7 @@ config MEM_ACPI_RAS2
        depends on ACPI_RAS2
        depends on EDAC
        depends on EDAC_SCRUB
-       depends on NUMA_KEEP_MEMINFO
+       select NUMA_KEEP_MEMINFO
        help
          The driver binds to the auxiliary device added by the ACPI RAS2
          feature table parser. The driver uses a PCC channel subspace to

are made to be selectable only and so you should select them because they're
non-visible. Just remember that blindly selecting things is evil.


> >> +			sspcc->last_cmd, sspcc->pcc_id);
> >> +		status &= ~PCC_STATUS_ERROR;
> >> +		writew_relaxed(status, &gen_comm_base->status);
> >> +		return -EIO;
> >> +	}
> >> +
> >> +	cap_status = readw_relaxed(&gen_comm_base->set_caps_status);
> >
> >Is that register read always successful or you need to handle errors here too?
> 
> Return value of 'set capability status'  is decoded and return error code on error case
> in the below function call  'return decode_cap_error(cap_status)'

Yah, this is not a common coding pattern. What you do is something like this:

diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
index 627895fee143..4caef7f2c4ea 100644
--- a/drivers/acpi/ras2.c
+++ b/drivers/acpi/ras2.c
@@ -85,7 +85,6 @@ static int decode_cap_error(u32 cap_status)
 static int check_pcc_chan(struct ras2_sspcc *sspcc)
 {
        struct acpi_ras2_shmem __iomem *gen_comm_base = sspcc->comm_addr;
-       u32 cap_status;
        u16 status;
        int rc;
 
@@ -114,9 +113,11 @@ static int check_pcc_chan(struct ras2_sspcc *sspcc)
                return -EIO;
        }
 
-       cap_status = readw_relaxed(&gen_comm_base->set_caps_status);
+       rc = decode_cap_error(readw_relaxed(&gen_comm_base->set_caps_status));
+
        writew_relaxed(0x0, &gen_comm_base->set_caps_status);
-       return decode_cap_error(cap_status);
+
+       return rc;
 }


> >> +	 */
> >> +	if (cmd == PCC_CMD_EXEC_RAS2 || sspcc->pcc_mrtt) {
> >> +		rc = check_pcc_chan(sspcc);
> >> +		if (sspcc->pcc_mrtt)
> >> +			sspcc->last_cmd_cmpl_time = ktime_get();
> >> +	}
> >> +
> >> +	if (pcc_channel->mbox->txdone_irq)
> >> +		mbox_chan_txdone(pcc_channel, rc);
> >> +	else
> >> +		mbox_client_txdone(pcc_channel, rc);
> >> +
> >> +	return rc < 0 ? rc : 0;
> >
> >So you mean simply
> >
> >	return rc;
> >
> >no? rc can be 0 too so what's the point of the ternary expression?
> 
> This was added to handle the case rc = check_pcc_chan(sspcc); is not called
> and last rc is returned from mbox_send_message() call because mbox_send_message()
> return non-negative value for success and negative value for failure as per the documentation.
> https://elixir.bootlin.com/linux/v6.18-rc7/source/drivers/mailbox/mailbox.c#L241

Why do you keep pointing to some indexing service? What's wrong with simply
pasting the code snippet you mean so that I can find it myself too?

Anyway, what's wrong with:

        /* Ring doorbell */
        rc = mbox_send_message(pcc_channel, &cmd);
        if (rc < 0) {
                dev_warn(ras2_ctx->dev,
                         "Error sending PCC mbox message cmd: 0x%x, rc:%d\n", cmd, rc);
                return rc;
        }

Also, cmds in hex please.

> >And what's the logic here? You'd capture rc above from check_pcc_chan() and
> >even if it is != 0, you'd pass it into the mbox* functions? I guess that weirdness
> >deserves a comment...
> 
> Both mbox_chan_txdone() and  mbox_client_txdone() required the status of the
> last transmission as second argument.

Yah, comment please!

s> >
> >> +{
> >> +	struct acpi_ras2_pcc_desc *pcc_desc_list;
> >> +	struct ras2_mem_ctx *ras2_ctx;
> >> +	u16 i, count;
> >> +
> >> +	if (ras2_tab->header.length < sizeof(*ras2_tab)) {
> >> +		pr_warn(FW_WARN "ACPI RAS2 table present but broken (too
> >short, size=%u)\n",
> >> +			ras2_tab->header.length);
> >> +		return;
> >> +	}
> >> +
> >> +	if (!ras2_tab->num_pcc_descs) {
> >> +		pr_warn(FW_WARN "No PCC descs in ACPI RAS2 table\n");
> >> +		return;
> >> +	}
> >
> >You need to sanity-check the number of descs so that the below allocation
> >doesn't go nuts.
> Sorry, can you give more information?
> I am wondering the above check  'if (!ras2_tab->num_pcc_descs)' { } is not enough? 

You've done what I wanted:

        if (!ras2_tab->num_pcc_descs || ras2_tab->num_pcc_descs > RAS2_MAX_NUM_PCC_DESCS) {
                pr_warn(FW_WARN "No/Invalid number of PCC descs(%d) in ACPI RAS2 table\n",
                        ras2_tab->num_pcc_descs);
                return -EINVAL;
        }

The RAS2_MAX_NUM_PCC_DESCS thing.

> >Also, what's the point of that pctx_list array at all? So that you can do uninit on
> >the ->adev in case you encounter a failure?
> Local variable ras2_ctx  is updated when calling add_aux_device() in each iteration as
> add_aux_device()  allocates memory for struct ras2_mem_ctx  for the corresponding PCC
> descriptor in the RAS2 table. 
> Thus storing pointer to each ras2_ctx  in pctx_list[] to uninit all the previously added auxiliary devices
> using auxiliary_device_uninit(->adev); when encounter a failure in a later iteration.   

Looks weird. Lemme look at your new submission and see whether I can make it
better.


> >> +		return;
> >> +	}
> >> +
> >> +	acpi_ras2_parse(ras2_tab);
> >
> >This function does some table sanity checking and warns. What it should do is fail
> >the driver load if the table is broken.
> 
> Sure. 
> If acpi_ras2_parse() and thus acpi_ras2_init() return error, can you guide
> how to handle this error in acpi_init(void) where  acpi_ras2_init() is called?  
> Something similar to this below,
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c index b02ceb2837c6..8b4fc572a05b 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -1475,7 +1475,12 @@ static int __init acpi_init(void)
>         acpi_debugger_init();
>         acpi_setup_sb_notify_handler();
>         acpi_viot_init();
> -       acpi_ras2_init();
> +       result = acpi_ras2_init();
> +       if (result) {
> +               kobject_put(acpi_kobj);
> +               disable_acpi();

No, you certainly won't disable ACPI if that RAS2 thing parsing fails. What
you should do is not allow the RAS2 memory driver to load.

Lemme look at your new version.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

