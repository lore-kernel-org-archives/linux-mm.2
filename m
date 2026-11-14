Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B9A606A885
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d0Ko838s
Received: by kanga.kvack.org (Postfix)
	id 0A36C6B00EF; Sat, 14 Nov 2026 06:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054436B05B0; Sat, 14 Nov 2026 06:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85A96B05B1; Sat, 14 Nov 2026 06:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0FD86B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:55:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 360F212035E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:55:40 +0000 (UTC)
X-FDA: 85433570040.28.2EBFFDF
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5A800C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:55:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d0Ko838s;
	spf=pass (imf22.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657338;
	b=LWiRa7kpeUa/TFouydo2fYrlAbTKfNyJE7KVQY0WJWfOTbVue1Ph/lQjgimj6D5+qgGDcF
	mq0+k14tWd3t6jqCaEFWwvga2wrFhw0+zQ1KIaZaTZZYc4ZskxwWhgXaLGTAFZKS+V3p31
	NzC+gKVatClemyXcU82kEnNgZbwY6f8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=d0Ko838s;
	spf=pass (imf22.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
	b=mKVM1QdEFeiBN7PNesehpbwpjIMnQz9sgr/9PtpNiB+VVen+95i5T5CNlNDYALnolWJKK2
	Rst8F6Cn/y9h4VXLib0owvHP9uzR6UPu/M6w39dNpioeQ8l04h0GFUtQaaVYuVBEeZzIgc
	IX2bKh8hdN9kvd+jXrMQ0Fh59zCznUc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c50604721c8so370135266b.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657337; x=1795262137; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=d0Ko838s8X+0paKhHLoh8Z6DJO2CDMoITUZIcfJuDfyqnPO9BVOV53iQ2cvRyNCsH4
         m4CLlAfSFIFMa85kJ9cbtRNY08bpDjJi9nyv2HGQGC6xlzEOPNmWAxxHl+L6rPI9OH7H
         HiTpkhNLFewh6xpYMto4UJoFNnl6DwSqheDZbWvnUNlhZteIApNhFLoIURG47CAO1guV
         LfkAiu4S1+krfmLrsZoRFIK861rb/UsZqHxs5p4owYQBNHXKt8XFnxtUGfw6Be7XlT5Q
         tK72VN1+cP5t5umhhEDxC2GoQ3P7Y+cdTHax8OrAr9uWVdAOt6yYh3JpVj4BqyjOpV8y
         ErZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657337; x=1795262137;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nJvs09p7QWIuuw8YOzj5TR133+2IJ5+yRajckn/hsO0=;
        b=IrjvZuS59adSlLz/6hJGwJtCotz+o84Rffa/QOjoAD6bLuYvYBqXJAS1xVGgvd/lGQ
         337thUVm/eModyvPVMOnk6FA5nSIjwke+vxnbg4aRcwF7cqFCV1wvfRAKtO6r0ezla9F
         eepLEqGJ8VhF9ldxelkZKIl8ao2T+kBHFnv3Z83ElgCxJf/MuXpJ3tEOX5eCybFn9Ez3
         sss/ngb72I9foSbzPrVJ4DlXgBMKJZRY7oAQ7IyhZYFJyuAwQzlEFklMWE+AbyD18bGP
         ztUunjkxLqBCyGNWFqCZ+OSr15Z4lkdlIwOG2JkBw+ZPrsTKTvdUkAPC9RGYeaBUoVG2
         eJEQ==
X-Forwarded-Encrypted: i=1; AL+hErFP8UQrgcyZOf/8oHtx+9Bwa/06msZpd/mhIX2cIW2A21n/hhPrp9fLQNlwfxopEUgoI81xL2ZJ4g==@kvack.org
X-Gm-Message-State: APuU4Z/PvL4HQ1m4dYmR2yoLTH6p/zo2ZZeo3h+OnanLici4RDKqNv0Z
	au6Xfa9DXrhAZLjJSLhcR3Rbj5cQ6WJAm7ABn6bEn3mDlQ+i6E9NqceG
X-Gm-Gg: AYBFou0gV9BtlnFq2O2w2+HB93e2t4FPPbbPfo4+avh/zAa9PjxH9X5JCVa6oV0PCKj
	YhyApv1uwCDS6zUQpmTGIUWMabnW3WrAbzaUkHaQSIpxViEX4AGTMQp6Q765zF1URJ3skQ77MLT
	xGs90mTKPf8n8LTnDR4yCVxLIqavubL9uuYscYtE5jQ/xpsgvQXZbHEXSjdnp95jjgzS+BsceM1
	6WyQGxWF+5aU5mmcQq+nbbmPtvCvnwuVewM4VMYuhYUyXgTD5MApwE/2/9G4CpILVrSnQ/A2sbd
	ZYMjqIfpdzaZO2CnVqF0HPhmiOQrhYRTjghqCPvyqi7cb3XheGHmXsnSWTmgv9IaDNnIIfglIML
	j9ObZi0Fo+ODyjQw6viGrRmiOK7yYOw463jMmdndmqvQYdeJ2wUc4IcWqEb8Raj+Nqf+WYyvCJc
	m9lgn8oP7jlGWnHl55xf12RfjDqa/p+3wSDtWBt0cMpAHSFH2O2NBSgdo3oUKCU2To53RkGKjm3
	i6ri4+vDdplEJq32AMJERvKXVr5LZyWyiaRhwNy1AjmwhHaarvAru90bXuLzlERokVP9kRhgeyd
	UiJfuET4Yr7hOCoP9+sM95Ef9tddKc5sXZ/loY+OhAwi+88pGzePOp/C2URjJYVWmFvFmipHaSa
	SHjeD3tv1l6g=
X-Received: by 2002:a17:907:3e10:b0:c40:231:6eab with SMTP id a640c23a62f3a-c5096370c31mr441592966b.16.1794657336589;
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b41f44sm206223866b.31.2026.11.14.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:55:36 -0800 (PST)
Date: Sat, 14 Nov 2026 12:55:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avhMN39TECaur0sS@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
 <20261111151202.GA11391@lst.de>
 <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A800C0005
X-Stat-Signature: 8t1j6hkgzb4htub9w95bh6yye8i7k356
X-Rspam-User: 
X-HE-Tag: 1794657338-579983
X-HE-Meta: U2FsdGVkX1/FTKJOD5HKAjv8wnRjPvViens77RWxU6TSwxwh59DVrPQZvQaRvmPyutcCFCfULJgZ5I3fvP7DKWB1Y+KPAdJCG8DNamfmbB6Vq14WEj1AvVud6pNnJwkyYXxZ57i4d7byxjq/jVMBeCb2H5a2+/VB5ZRFzQbvYKt7qlaYQO6uuk0qEmia6ZrVOhHJ1AXbvWlZVaAap0hcRcgdhgAHTYuDQTXmxrucOj873HJSHKLqlMWyFJhhnSzQGQwkEQiccpK36NeJWm/u9Ecv+WaUag1oh6mqHZbIJFXDavyqHXBXCt7/lmq7iBsumM01RhfQwfQXkTwwqUDgENm63fHfxle5eOBEFurgsRwgGM30hMUmE7BafBLaZSDo+6qluOZd8514ykWBNfP6wEfzhryvxuwg/inJnkTCowhg6cuwR4CfkRTf7nr7o3fZg90E/DIW01Rv8zGbymA2SQ+6A1J5zUNC7l/tj9ImRJwD1U+3b+RWpvMngTgehlOEfTl7m5I7FHD+x70kBVlPdROTLUufC3msgqik+xFzgnwUvJs12SeMZY5Z/AJVDUoB/lCnAlgiEMQCn4P+ippajdc3HOLgpt/6gDCYdj1WPL1SZKcnCRwZ0WQ551oXnX/2tqHXlTe7gtX0yqpwyTYW0b2WpQW3cvN/GCdFydhHLEs5NO8s5uA08zbBg4ASqdOZlUfGg7tN2MTi8i+W64gcPsqWxXNtSD0Qqfe+eFdB8uU93XNNRFWCyMaHO5836/I0Nswsjm9tqYpB/MlSfNInvy7l7KM8uOa4cAlDQdoUKCcLjT+XOXv0F0dsC2MwfM8yPfmLgtwz3NLXw07sJ42fvAY8/8FSeG2sNqf45vQE8Fg/0XmCqMThc/zR5JEmLo0pfc/JjrDJN5fOpgs4ZsfSUr9b6W4FOubIO6rywBLx2MIHwJ53BXJOLCds3pApDCVh+0P7d/M7F+kIXVnna0k
 dp/aW5mC
 LVFoKK5Bupxw2mMlsM9nxehyLKWX661DGap5220hK4wJsXQ9h6x/U+r9ew8g3gzA/Lsi8JrnUncGpZudZ15ZxVycXnZ8KYTBJsHixQJ5T9bIcEtPgH1ZnANIY2HU0fHFYtqU6T7ypHOrEuomAEqr+C/N9itd/5wSkz3BWNSijt2BWT6rpVzRGI1OlxKq6p9s8ZBf1jyjuWk8eDKMIMdxOkQc+cUNQeVgkHoXU23JK+x9qX4GA5ofCQjmnQewTtBNH0BecqadYXR9zL6Wjo7bk6tMpq96wAox114xX8lMPsnlI0JrOg72DZ6ICEP7lfeA6yaG3wdZ3c1otXzmPAMRodvmb9Wu3UDSzypSnaEM0l/ujp7SbNUuLBwE7E66IkOlEV7vHSiehEp+qu2Zj8IIz+jE4r3TB+rcra82tPIQyT7v9OrI5eDA5fd7W5N6PRGdqEoJKa3s3u5zQFGEbNeXB/xRRxS4pbGNYgtX3x4LsHO3iQIkGPMdjX0yvoWNuW1NHKA1tp0YJvniH9b0xtg3z1GpsmSGf87LHmEWCyfuXjfesYWUsRddhe4kuhxVpZPrIn5E9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:25:57AM +0100, Alexander Mikhalitsyn wrote:
> Hi Christoph,
> 
> On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> > I've seen setups where people use fuse to mediate access to sysfs
> > sysfs in odd ways.  No idea if that's still around, but if so, this
> > patch will break it.
> 
> 
> Oh, that's painful. Do they use backing files for that?
> It's a relatively new feature in FUSE...
> 

Very unlikely that they use FUSE passthrough and if they did
very unlikely that it would break their filesystem.

The API for fuse passthrough is that the server requests to setup a
backing file before open via ioctl and if ioctl fails (as this patch
does) then server falls back to non-passthrough open.

The ioctl can already fail for many reasons such as MAX_STACK_DEPTH on
procfs as the commit message says, so server needs to cope with the
fall back.

Thanks,
Amir.

