Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DE2E67A68
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 05:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058E96B0005; Tue,  3 Mar 2026 00:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006B86B0088; Tue,  3 Mar 2026 00:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47FA6B0089; Tue,  3 Mar 2026 00:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D00006B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 00:16:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 705D459AEE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:16:43 +0000 (UTC)
X-FDA: 84503591886.19.26C453A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67E73140013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:16:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=WV1xdUM8;
	spf=pass (imf09.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772515001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GP/GiWYeS0pMiBqvJFMNVE6SyM3tMRMwuL8KlnPDFIo=;
	b=oXW2AiQJ3CxEmf72KuGKUkpILkRXCo6JgNzhwmwukkpnZjUVrdf27AMQPs5IQ+iJsBnYKn
	Vm+LJY+pd1/uyD/voROImatFPj7I6LZYwsMonjvRMyBN2kCeUqoZenbW4qMtE02hgwKZ6o
	e0+pQJTc2GoESHvv39wroAV8rBhA9sI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=WV1xdUM8;
	spf=pass (imf09.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772515001; a=rsa-sha256;
	cv=none;
	b=0zUJtIitNr9EFHofPYmupB4PW3mUqsnkwZ0RNhoi7XcchN2q3srYUYAsHm+XGO60hTdXdF
	ZaFSWqFED08wQ3Fqy8Jvs33VZ94brYvEuyTTtAgUYX8VYbh5WGZm3dsgzf8kH/FJIeJvPX
	Uv9ZMATe36sq19UK6+OqSKmPmR7BGaI=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4833115090dso53837865e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 21:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772515000; x=1773119800; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GP/GiWYeS0pMiBqvJFMNVE6SyM3tMRMwuL8KlnPDFIo=;
        b=WV1xdUM8x6C3xKlI+sroTx3zZyVO0NWUOwfjVQbae40ZCSyKHbkv+egvxslma3ITm0
         xrL5VsexmkooQqryZ9/c1DlcGbkuf+431V2dnGfVC2C+Z+yCUAcKRQH6P4yDQr5CF8sI
         29uCactztMhmMaj7FHwn8p8Z3Mkyj52psjlTjbDSUO9vOY4g0iQa1ZKfMAZviQ7RC07m
         rObDlOL8oyKrZ/TqKFz8GJECquQv1pfUkRFJCAuTPA+DNe2FxD6E83culmvH9oqz51a+
         9U/rvEkUYpSwZ1LQCtSges8QsvnOHcVnUieo2FWpqsgD5uQOZn1VBPcWvzR9001q6bkg
         R4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772515000; x=1773119800;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GP/GiWYeS0pMiBqvJFMNVE6SyM3tMRMwuL8KlnPDFIo=;
        b=OkzPtA3Lc/8KjkJ3Eje5ogN/5W6er+50g/JHbYUDInhhT2y9Mx9GmgBNjVZUhEWtlY
         reqgb8lbI809xKI5z++OWZgY8Di5dlhVRhhZSSMnVSQVjmjKEkBoSMqL2yZxkA/arnyH
         DS1B7tpR1WfE2BQeZfE+2wNerxp46mF5vF2p2jaEzMstcz19xYNbjwXsDVl3NnMv7034
         qBKCIFwjhyQ7YCo6oMRH96r6MzGSHnP3y6NpH/sIzzv/u3vlAChVXsucE+feUy+sgh8S
         V6u2z7fkCyJEWRitKgZrv6pbF0cHxSbZPVykVGq919Bm4h7L3j1i6ykADUHFVsl/h9PW
         YmMw==
X-Forwarded-Encrypted: i=1; AJvYcCXpzly/kG9s/u4vxPrbkguj3yi5XGSoWAoHbNPwo/zs5luA8vFZrs4vJnozChzGF1r4JbXaK05a1g==@kvack.org
X-Gm-Message-State: AOJu0Yzl+tBOo3F2QuyhD1143GJXr+6XkiKWeDX15NeNvE2OcowGNs1G
	dBuugFAaLLsqY4SAq+uydfSBiY6GQK0/hoeHf+tuF/Inr5HqRxvC80UZ4UDGy5fjkAg=
X-Gm-Gg: ATEYQzyi8IaWzt7r3TyK5h51soMdxUCmz39SmRm57klhC3jSJKpSbnRNCBgcycbJStb
	OVdtdGCgvTtzye0finQeIldLXKcE7sD5Fe7ZPTXz8VznCYydVhwUhbluRnVlzt4K6TxRLSekZkk
	hZ5wEt0xlpAzj3ZeZ6HNlk2iKouz+swxeLwjhosksCXMWjm65d5JTVAGa46AdNmFBJMs/z7LIa8
	yJL8gxfpzy9hE/49dbliKlgXEQpJLwC86kcb75B8rQ1LyjiqTFIAiuTudkCJG8mKf7glAOyos4r
	6I8SBFlDMxs+0dji1fbDwejn1rSNwkhCCFS2LJNsB5td8oY487uAcyKxsqvZL8QWl/u4RyZuShf
	fJK+LUKMoeMDyhk8Woy3yShEoujMuCcnrXHWrIHk+JOKiHOHmXCjv8wH2NXgcl3UtZOxGxmNWfU
	yHM/2J/zf3x7neSQrNLXeuzc7TW6oSq+n5IC+Z35I=
X-Received: by 2002:a05:600c:3108:b0:483:887:59b0 with SMTP id 5b1f17b1804b1-483c9c1cd2bmr278984465e9.35.1772514999496;
        Mon, 02 Mar 2026 21:16:39 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485133a9511sm8016005e9.17.2026.03.02.21.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 21:16:38 -0800 (PST)
Date: Tue, 3 Mar 2026 08:16:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org
Subject: [bug report] kho: update FDT dynamically for subtree addition/removal
Message-ID: <aaZus68Dao_6Ckwf@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 67E73140013
X-Stat-Signature: ym9yirtoiap88gm6fid1pe866q1za1dx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772515001-633020
X-HE-Meta: U2FsdGVkX1+oOfBDiGJvXl8YNzA0UDoew2/k9A/ZyORzRM+AeJE57et+Zx8/giGIPVqcxDwakvHdeNWKDw+6t04/VbwlFU7fwFioi82H78f/nJoRafxtsKpng9WKQPkFo1ngiffp0KxEyQkCmbTFGj/J2QiN5XV9Pr4evDpA34L6Y2mlcgPzIho4TupK0Sy8K9iM5p0HzTQFG8Kim0VaBINNcwTJ6jwgaD1i+aacmJlX8HrR/MAVKALKFNF5Rs5lwMs99Bbq6w1FoYeleU1v/FjF3dpR2q2KL9Jyu368w1rs+0EW7K0KjDhcJuoKEwWgCDc/9OHWpGTx3DvS/vrPA1Zmq8bNkYkbnj+hYw/srSedMz3IZf4g5+zmoQ1GJm/WbhC6SR2mhn6WZfyHtf924YafTWOhLpSsBwIWs/tievtomuSg3RJOnjeQfTDkKR84p9RMvb720GE/uX9sKcYYluaGPzzCArarUG3XoJNotGwDeg2ZpdF2w8QrksJ+oucoCtdYWfPH1gp5H9HGBJzAQhwBdu76sDaq+Du/UPGZt909jes0YhFyGloBxELkfeVmZOG/8OjG5kVK+2DLZIHVWW28ryBHiv6fIppTJUpQaXO7n7HPXheTdTcvYjFPcDAiwTp0NWQtNLNc8nOaYq7Fwm7aUyQ/ctKSkQXuR3enK3fn0cbJiXqxD3bXpTuPkv6qKBKeGLZGxconn0nAWdx3kzamMh/GrBHGdYwOpy55APFWeKf5pfngEeS/5+StoYs31mkr29swE8Tjq599bSP3b7ONXIrYNPuJC0Ui1gXrWx7R1fycj4HR1/0exkDU38G3OoBafYNlJqF2s3RbommlqOy8zA4HgqPlpU13kRaLz+5m2f/973KHrS4TPbuuSd/DvaRFx71bN3pp/E9SPvFI9CeKsMIlw77xmzFhSzh/wPnWIQa5mThQVh3TNzQvlE6sF8gxKAUSJ2BZKVQbsmv
 9fC8+H2j
 dQt7OljhvTgC9qjfgRCtnZNSGHZIPqcSwAN+mU10c66J7P968n5I3qniYeQ2IIvTEF8zbjDtTa00aaJ6wyMqQ8LK/EHfedpjqIDuQRZYGsVaBOLHxb68krfRQ1Cjs4f3sUEN+rYwIXls202mzX+zsGlAFw3BfMUzR/W1yzIpvoCCa0g1hPywgBFEvyHAte4ma+amnbzvB4oXaSLfTN6dyUhsJU8mb4cdqkxlEkYxqycvvl/wE4uRj42q8dXnNTIk1ZW87LJsLh8COkcjlxWPJFy5kWPcTOhWmIK2X7sLOPHBp4tK/8PJk5TNw5+3mAtrX3oiJz23LGRaDtEUF4lEHPGZVHv0bIMYEJszyIPwA67JppH/iTuRSj0n93zXh5xAQfWX9sC1zhbOfkVnGmuN0K7aMNEu+selKlanBlX/gBEBBZ2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Smatch checking is paused while we raise funding. #SadFace
  https://lore.kernel.org/all/aTaiGSbWZ9DJaGo7@stanley.mountain/ -dan ]

Hello Pasha Tatashin,

Commit 8e068a286aef ("kho: update FDT dynamically for subtree
addition/removal") from Nov 14, 2025 (linux-next), leads to the
following Smatch static checker warning:

	kernel/liveupdate/kexec_handover.c:777 kho_add_subtree()
	warn: return mixup? 'err' vs 'fdt_err'

kernel/liveupdate/kexec_handover.c
    767 {
    768         phys_addr_t phys = virt_to_phys(fdt);
    769         void *root_fdt = kho_out.fdt;
    770         int err = -ENOMEM;
    771         int off, fdt_err;
    772 
    773         guard(mutex)(&kho_out.lock);
    774 
    775         fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
    776         if (fdt_err < 0)
--> 777                 return err;

Why return err (-ENOMEM) here instead of fdt_err?

    778 
    779         off = fdt_add_subnode(root_fdt, 0, name);
    780         if (off < 0) {
    781                 if (off == -FDT_ERR_EXISTS)
    782                         err = -EEXIST;
    783                 goto out_pack;
    784         }
    785 
    786         err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
    787                           &phys, sizeof(phys));
    788         if (err < 0)
    789                 goto out_pack;
    790 
    791         WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
    792 
    793 out_pack:
    794         fdt_pack(root_fdt);
    795 
    796         return err;
    797 }

regards,
dan carpenter

