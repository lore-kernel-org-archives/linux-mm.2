Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8067CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134108E001B; Wed, 24 Sep 2025 16:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5268E0001; Wed, 24 Sep 2025 16:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE598E001B; Wed, 24 Sep 2025 16:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DABDB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:36:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A74F14018A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:36:46 +0000 (UTC)
X-FDA: 83925302412.14.6232719
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38110A0004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:36:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ojvudmef;
	spf=pass (imf25.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=OrIYdXyq7e6b5pkRFDVA6nxXrztl4hy+WT0gwfnDpdO8WD9d7S4D6NYlopoHnZPxPb+IVu
	Eb9uQtLgnBnMKXIFZRIRMKW2duh/ZouTZ8x4MSLExkEK9QNEhiqA/A8+B5fCZE0eN8Pgu4
	ubMiOIu9++Hd2Eto2dqUcVrxoiIGepo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746204; a=rsa-sha256;
	cv=none;
	b=KFsXcX/ODYqDGSUg+SiVfGQX0qXqytrnULsLJRi21PQMeZjSoDWYZNaW8dZWK08nVqwJG2
	h/lQOr4hm433f0LfT/UNo8fS3+dRxEQb4+e5ZDypc74siMh9TWSG8gACc3rtS5gQmf3n1N
	INm8RQxpga9sW/5wO2CjH4e483w8kSA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ojvudmef;
	spf=pass (imf25.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746204; x=1790282204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=ojvudmefyAgFBNHWO8T0gQdA0MOZppq6e+/S8SlDRMsN8LDxIpdSc2gd
   O+lfhP//6Ji/a4ERz2f4qSFLgPEuFbTcw+7ySHzggO5a3ZiD5QeSj79Ac
   vlJ5kaQX6hEg1WxnAjX9ss7aS5GBj/PXvcF3zMGHygVbPaR/YALs3c9zN
   tOWO4ZWbUHthMzyH1Ij3PjCszs5PtcxwQSl7E6xxJOLnNbmq7cq0ynQAZ
   kTJcU65KegmOuhFplCSDE+Z1FPxrxTDhjvDyMnT/sXyrP9IX02SBDgQHh
   dtlnaEzc6aE1EWGRD1h63USlQgiXjNWl6FPBvaXTliOpc9VjlQ/MXZSf+
   w==;
X-CSE-ConnectionGUID: kb0ojWBxQquIo7b+A20p7Q==
X-CSE-MsgGUID: 3HJY1uZTRPStEEbVVudamg==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2631102"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:36:42 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:12645]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id b27aa07b-d914-4c3d-9271-6483e848842d; Wed, 24 Sep 2025 20:36:42 +0000 (UTC)
X-Farcaster-Flow-ID: b27aa07b-d914-4c3d-9271-6483e848842d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:36:29 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:35:53 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH 19/19 v6.1.y] minmax.h: remove some #defines that are only expanded once
Date: Wed, 24 Sep 2025 20:23:20 +0000
Message-ID: <20250924202320.32333-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: uxhxrxaeyaqxp47ii57nz671moey4ufg
X-Rspam-User: 
X-Rspamd-Queue-Id: 38110A0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758746204-453338
X-HE-Meta: U2FsdGVkX1+aJshY0hYci/a/+KqtjjeoqSziY2q5Uco6C3iyuVoQkEOFr6ZHWzIxgeGJMtC4KFQnNtBd/8A1exRL8VT+1TIYd5UbNSNZeYorcnAj6yIKjeHKxh8muOb3p/4gL1mJeshdD2W7Lgl7IkSIiD+17UfHPN591Y8ZcrDdXUV3+uV4MMHNr06PMg/3KIS+2tpoVZY4l7MLgoPwwFPWOmXv8cxH0db199uNM5GcrB6ZMhwcrM3gwGO9Y2rI3viZljOB2NDBg7+8v6XtFrl0RPrmhc0VJflqlo0+GysyoSQf+0aKykrJPrDvgN5lbjTmeMUIDckZN3hdBzpT+yf+LyHHXst1Dgo8wedVUZ2/aKh8P34DH5WB45SJAiep8W9xu6bNne9l1b25QaDGg9MhfbRySRwLfMMpeAQbUJ6TLW5pT9dJmog8WjOO43lhMRf6MVjnvuZ7wqHaxr1/19mAe7BhRBPe9ENY6Y1WVtuM8iWChTqkOrCnZABeMdjsnWayaYNx0Ez6uVa8G4kVZUDqhS43ozW+PczpR1l+sC9Zw62GRH4DHMP963aXw4TtDEx3Du7FZvqaiqNFj3qMsoaR+pdwhPmGckmsUUeaaeC8h9OiEQ9ISktittHG7phNSEJA3XqooTRWlqKYm/BvHDGtAS3ilks+sRp+zJ3YxixhHb7U+DaWsxFFL70pB2/OoeWMFclohbmoj+c1pBguHVLgVkfdMl23haauvTefpaaLtdX+c0bojuHd5ZdlbyxEBIRPI9x92Ixl0GGFGf/wD4eOpx0TSrPZG0cAWGW/Vn4RzrOXTk5zkVdQuHxayiNRYmSNkjcxNKoRgL2flO0Lt0+zwZdzWObhYZ559Tqo7E9gQ3MMsZw297/YIyU34gIEV9x7lVtGnJivCcwQSeIDV9nHdTo9jKJvuVxsrz6DJPkUjEHOetYIlqKf/jbvB45iKsV6uEB0oWnMUow2AYM
 qrBfw1Br
 QIgIjHJQz88VJQk+bK2LbcfohurNIo65LzyOOJAJx38xA8tBMbbbm1t6xJfcAC2kOCGS6aNKqEN69OZNkBLThZplW95RNqt4aTy+vDq+KMS9t9WDbihdper9NtCUXwTZYCzQI5da/i3s1RUYM5l3r46biwJdx3MOO4fJkBKwIE55at2MHre+J+cTM/7ItLvuq4e6SQjrEuBpIa5lQPLLPWUAr3w/LeuGnVwF0CQMChlzPYV5AldITMmTgOmKSCGgpRw4vG2pj1xImI/NG20wlLX+HqFdR5bDApjPfEX2t61KOBA+OhGnJsFJKYsU/Oj+nJK3Z6W7+5u08uVoTEyO8yopBX2CLoabrHbqPb9SgWNRDQBqwrWdHMvWPnG8hZxZuc8oRbhw11uK/ofx+FiUIxRadJ+4+W7jg7JXGM4xT8dNZi9kQOQBHPHMumd9DNyiL+D7aKzwgO8GDbVCQI2pLpAEmlqaSqWG/9b2dKCQ53/jPNv/26f1XJWD2sd6lzGl1r0glebQSam/uy5xOavPiotDHd8q+gDFJ6LefC2mI0kiVIgRpaWJN67bvvYVVzcpI8SpICAXWQy+km2jlcA9ZkB1p1xBexhVja2+xg+Rhrpw/lAbUGqF+jQR4dqZwjOWulcjkLN3We7QLDyr//Z43PSBKmKD9Brx4GVLSHXbxL9lvTRlAYrYRN1eogFTZ/k0G/jp6alCZip9L8z+uhwbp7TITHj8FhNphLqb9b58DjAmIN2FjQcQS3eGPFxGmqB0LNvLnJTP0AxlIVRj/zIuUtmMEbGubIuTILf/FKrPEybk4oOJy0jojQMrvYQPYrX95CmF52vPghDpDWeOUAVYh+lCxQdUZJtzlXoJkRqr43380zu4fmUWCwX4RmC4FRGg6VulAUV36Cn5pKfOFghJdy5zB+IWwEsQcOK1ds79oGePBhORJyVEDkybyG0fAJdQjWW8nttTNsINR+pF1YL8NR4YTBTv3
 oyYQpBHZ
 ZKYJFFOMZfKfQlAHJa2OTRyLu+8R2x8e5LJn/9KVRns9g0L3RbxryUYel8yA6P5Q7sF36Y66zJWJP9e5Fj0jJLa6L7T/p0o5a7EFF3qsIfYE4KvEo6XFffoSUvW35DOfVFmRss/MQJManCrcF4rbFxDVTck+m+ytenLRJp5L5BRApqX7S6x2K0BSFZMEbtD0z9lHN2RK1YZpmjDgc+gTRQMvXPbteIAIm2sxksGBnbSWkQJBi+7Z8IwqkOxcJd0oP1kBzCXi6bLztr6dp498ZHsoFYz0UMm7z7pm9AP95zOstr7DHgXulndD3LATTerNh23APT/6u/H0U8ozq87qx65sBiMU+troZACd9+H8fBT+uFqrvbmHH3ND5LdLiRaqb7c7IjyTxONkY79VSzDoAsuk7Oue1vLWIeAsogiBLb4AYbQa+pWMwOkeqcWH9WRGdfRYKefzyMD5N7IYKIRhzbiJgd5qXE0q9SbBhxjL8buhNcdrckTRiWxS2nw7gCPx1ODCF3KcGlVOBXrlMm4L8TWvtQ/h2sW0hTffY0xvQgXynHNhgMYOMSY6CDq7iG0Z6rH5X71TDO9FDo18oUK0FtZe9jnxrsFYXBz1ty669pqG5jpT3Hhla0M6aeCY40J5bFoD+4ArJksOmNzYzfM+wc7uKbbMX5Vw+iZ2G0tScT6FOIlvXkJcpmc2vbBHqiIXEL2Twxmaj9thvWemGaM2Fq9mBXXlYcuVAjc+DTr0DaDYxxTwDd0OhSa0YnHduIyxxVNMSy7fxStE/RwrbIr9DcjFxtUm3r75oo/8SwqKb8giRbOSu/jgG8OcQKDMnW8drqUZaXeM/5bmFYcFFCv3VOO2DTtJ6uMWHEQrzbF14yx+rzVUnO4WA9/CCw0zAGjg9993K3FDxUjqKz3msA7o7xUrMxr8oLnb8Et+jMmXx5w9YrE6EfDnb5AijbCDj5K2F/38DjY8ddOegA5MHYZV0VlyRVB+h
 ZEX9vhW4
 knbKhD0/i5CVBgNxVircop95BYnHhx7+1CxoYH0c3mO0nJRX57RWN9N3ZgPmmzY23FzFKzADnuz8bvU7k6ren27AQrbTTvNTmdn1jE12V3u6xs5OYAc+J64v/9RvMp5vmHukV64Us5BpALdOUtk3walAmaWmz6oTGrkTXxQYLpM+/zJTD9zsoyYBeB+Ue2bORMMxD7fd+dyNGj/P3yYQMDKnrAUgLpUNRWan8YyHqhYXwhrJvyShhjV7ejOR3Oiu0dyKlgBRNsNVrYmtvMMayDO9lzRk94j5gE3fNSdZ9bbhpR7E3B5uOYA0EmPOLNgoK7hEtUigmu89+lSYqWT080mlLxbwOpZsS7ztmQjHihiPJLnzI1hyMaHmuQz/4LgILRHOiJfYaYlhtWxCqHY4vCvOYhrGsBL24Qb+qVdOfZEbZ25jKY+QTGrdBkVx1jFz2dZ+jxopQEDcPZP7EL1mTMDGbmFlzqjb22AaxPNxnPH8Mh3p9S8l1sHC8GGJ3Q9eUS4TKJHFE+SMJT0kLbZEW2ltRTkyopWogdy0gb+F0GHCrKtNu91jlnZ+vjM1of9acZAJ30LAE7JkFU9M6C7UVA7F4ej1fS8SdcsfUoCkLIQtvtyjbXLTyPyNr4yNAFFFiUGxzzvAC2F4dTrKR4QwHu58Ck6rXg3lKYY5WheWdyFkleA/qy8d/H+ts05MGVPKB1QemIrznlN1WN/T8ihakttDdKVtrRT6Ir//SyxZ2D4Swv51lSauwnkXMVbMCImMeqQETSTjzEHIClkacU8WDiKgOSOA+Q5ZjZpZqUJGVFJzH28Zg0Gvushn7Dc8DrSQcI6BhH+S3GwP/vOAefBxzI8w6hdG3c7fQE4zB7pgZOZp4g0kfTYBmE1RpAV6AJ9AfJDScJ2zrQm0GQ7kPGm+rOpfAg9qp/BUikMBnhAjHIbPNb0g2YqTyy3frKW/e8p+J3wLtaN8dOLNdzfSvytsrpTSKJg61
 qj2auJ3y
 gru83jBZRfBIbYd0tLEMK2jXbjpnu/1o/Ex4oYtFpRUKnYik0hydYSKyHMCczmtgVXl/hSTeaZXrtie7i4HtlEqdzE+UkcwYyN3JOT73mcg3kxwJTfgVI6PLuGZx2FztYV6tujBdFm3/risx7nYSsmsR9ySBI6xiID1r3awtSPeTZm4he9f5hVOzLxgPCV4uhdZtw1qB5oyn23Memrqz29Qg4EaY7nM6ujXTcp3X/RwcjRbzRoPgwgN0Nwmcg7kENHD2k+C6nioUXfMf1ZBW3kOSL7km8PN4rYV0NRkGjN+IBpGkw/CFHgx22ulkiH1EWh2lPCt6GgO+F8eShq6CE+gI1vYW1RwYaJ1NNOySOH37eLURCZ3raXQCWyuRR7cQRXivmxc18iq8QCtToGxGgoyTZL7pniBMA3lkFWOek0Q9zu2NseE0NPipaOK8ddiHora+z1fWFE7/vmEtnIXVh1ocje3G/3WhuFunQrF2nJlS6kEkHNgsK/qb8/hPwI6Xfw+09JsD4vaqZjKhTJAPa8uokYLPT+nl3w9SBcE3Eoz40MU6ZyBie10osYxln0EJPq+zhIBmJ1/4BRuKOFwqXntFVZSdqp2hjZxfqs3RGerj0IWLgLk/U6dwIzulYahHRfYSPNhxiw78Pv5hqQTMX6M29CXwQ4WpMNjbo6/rw3dfl1862SRqEuI3esZfp0XbEeeC+YCcYpO+EUcRXP+ADNzcpusCNmim+RdVOQNXEROA0IPAOEgBCbKaytNf+AuSsVIIdKvkRgOkA/3aj37LYJwSWG4ZrcNB5c7lZROtiNEuZQVz5P28xZit6aAwENbrYOushzwUt5ehIxsTO1BBou0p0/zyzi+mezlJzMfuzDrw35Af3l4jugf33iOrOZpyT97yXffRY6GYGUMMpOD0WXkfJz6kjvhLO8rX7kufRWCR51605NynszX+qZmWwKDuZNa1OQCzgb7zzniEIZUNmsncGtonB
 rMyJqFEY
 KxMSUdm7nSgQwtbFBSb6sLTJ4T807GKP7OoD4ckKfWSFmOXAiWUAqwM/WreqFMDpWA3xitjLmyvSiZSeucWHn4vFJLzuC4QHREwznpS1L1QtDrUGtyHJMRJxcMdaZkzHJ2rcxyguxfIuIYELwji95wNzhnTnCK43MoyhrGjDHqkz8qmG3DCvTZpj7T9seyOIO0e9n4ntblvzqFjqUqktJGD15luWa/dGH3jAAoF2cGPRvwzGQf5U4TOOiFeRSiO9s7l3YU8OFxPuoiMZv8YCOKnco6CeHekovGvghk/tWULzQno4jLBGfpu6YGylimnPj5kTax/9g0MtVxc8UFC5vQ9M11Kx+x2gMm1l1kTC1c7koz7XC2EwnnjyGD30=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2bbdd5b5e07e..eaaf5c008e4d 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
-- 
2.47.3


