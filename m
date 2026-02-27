Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3214FD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CAF6B0005; Fri, 27 Feb 2026 14:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424D36B00AB; Fri, 27 Feb 2026 14:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323B96B00BB; Fri, 27 Feb 2026 14:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3B96B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:45:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF1BD5B8FA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:45:43 +0000 (UTC)
X-FDA: 84491266566.06.585F949
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id E47A9100003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:45:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GSXhEPue;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Jbxq4nQ7cCHo0K9mO13qBbib2DHZAL310WhuqAgZmw=;
	b=1h39gm5zfberP91E4+cR7Yf9ZPyx8EXceAxqyiKrOwkvnptqxK2fpa8WxGjYQXr/HriTJ6
	4eVdPGJT8kTR8rZ0HbcpgLe73ER8Ow0Xi0kh5/f+reHPMr7P4SP7ZWDPMi6TBdGGOQRptJ
	Zs53V77kHwpX9FitnxUcdlWwVMqiAQo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GSXhEPue;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221542; a=rsa-sha256;
	cv=none;
	b=7ryDEv9egQj0VYJ1/9KZKdNeMPdyKahrsXtNDKiKs69RW88zdi5rou+Ld6ASd0EVVYLXgp
	NrE5LPds+3zCIXw8e14VIVP0VxH+UW51izYcBSZIiAwJfAMGmDL/su/e7/d34n4m30Hg7H
	rhTgvBEjdTHHd5fAjyMu/3a9lmipu4c=
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-679efb9eb0dso1812711eaf.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772221541; x=1772826341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Jbxq4nQ7cCHo0K9mO13qBbib2DHZAL310WhuqAgZmw=;
        b=GSXhEPuek/dTdfhhYylzRFUk0iH9gJXvoWEeZmmPA6iKK9/UCrSuU0LPmjMaSenb8Y
         H4a9meeuWl6bFwp6x6Jfl3sda9Swrpn59DZY6vvyOd8tdG8QifynR/YDNM9Hc7eNMqbA
         WWssl/niOp5pGDRmeZJff8vTacJljwEZ+OScuDzZGpvMZ7+M4NofZHF93t5PpKpQ8aaW
         ZbPWUXfQUVpV8a0MMTJ+X3PxMNl4nysWta3HsyO8FWJSP7vqFRCOOprx3MByPlH3Tdnn
         uH/45nUh6v9t8NKkMyOSfQErAbAWx2ruOF9+Im0E+RSB4JWi5pNt9lNiNoIasT2+N2wp
         z4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772221541; x=1772826341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Jbxq4nQ7cCHo0K9mO13qBbib2DHZAL310WhuqAgZmw=;
        b=mtb2hu7i+sN9G2zw6yQa9bQ61JUkdT1sHvolqu4ITILtNQE3S6qyr0cn+bao7lOlsJ
         b2wWOp1B/brl/inrvLjgf9Au+zRApCnKhCn/n6I5ZUH5UHA2a/TldTsvSvxREpJUI6RI
         MzWzRqoQdCJJUrdxFpTb5ubBKeEQ1vNMTpXPXhEDqtvxECLMzzNzV+cX0hntrzq/kEGd
         D5ZT1gDl8ZYfwltP4QijybAiLFjQ8G+yi27Wif+XLWxmB4H3ayu8sTOSr0C3hS/zk+GR
         BjXG0ok89ozGj7Qr+/wdT7TYey8RuC/TCIT/6PnP4gEGB7Tzjt0uQ5lJplviA66m2PfP
         ipQw==
X-Forwarded-Encrypted: i=1; AJvYcCWmvbzSqFUgY7BoMmEWP1ddX9piRQgfY0oEkQQ8k3vZZQAu7Ht0Rp6H7kjKoqR2p7VsoXghabzrlQ==@kvack.org
X-Gm-Message-State: AOJu0YyqEcJvgmZK5k82+kkkVj6sw2rrEMG232xo3U0nbjUXE407xif2
	+50pSgaCqIdwf5sKJHZLAdHAwlGTiCsT5/qzIh3bDWXabICgDM1BGVVv
X-Gm-Gg: ATEYQzytO+AXtVRAcUGjUjLWK+45wiDXGnVkv/V0jzkhoiWsXhelfjWlCkFw0stv57+
	HGSV14uBWAQX4Vg79g7YYIeJUA6/muRuL1jDNPMIyELQATOt4Bd+YKw60QnKl6ACZGbTNITrWYa
	z9aGTQl9zY0SI29DLxSSk1tzuaLso0jEeXakjj5JRurwgKPBGaUnoEReQMkId3LiERcj587nzK+
	YyJ/r1UrPJAFESPlB6S5LVBinD06GVH0aMq8w4J5Oj5jaX7znLL9il2qMT1naTbH3fO8ZpPn6Vu
	k0xWP6Pr+cOSC/67qIhkLqFMbdCpTki8BSXXDTRqwecuHLYMHvUr/jHfeKk2ylzQBAzphj6BZpE
	Z5gjbZ47xP9dsE+bR4AUFs093htWUFIXnTTsZ07Mkn9yDNRY3RwviSeYa2tqeduZSi95to4MnYs
	IWDL7TA2WkPZmVRemsOijg2Q==
X-Received: by 2002:a05:6820:8187:b0:679:e7b2:9fc6 with SMTP id 006d021491bc7-679fadc292emr2651719eaf.3.1772221540840;
        Fri, 27 Feb 2026 11:45:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4d::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm4162972eaf.7.2026.02.27.11.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 11:45:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	oe-kbuild-all@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
Date: Fri, 27 Feb 2026 11:45:38 -0800
Message-ID: <20260227194538.928770-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202602270607.dJP65LGH-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E47A9100003
X-Rspamd-Server: rspam08
X-Stat-Signature: gnhjjz1igb89474iyts1tyqu5x67e1kw
X-HE-Tag: 1772221541-314078
X-HE-Meta: U2FsdGVkX194pwiaoFQiZAdWDJojs+YipVvTFlDRFN/a8jzJvika36cg0pBWbmNo8aJhQjUlMGt2cyHBEDyapyW8FnlOM9irlmS3FdswJtNZ9jybGGouuX4Sb3+KEI9KQlfaGJPsGdnYl08gHvq+kUqR892XevsMfcK7QR2OTe+hs32GZATHrP/WzNR2Pz2ctbcS1wOp5eXViPvEewo7hdsd2GVZc5muZtZT9wZxyiYFPrsRNq665vXFGBgxjCQ19IOp2I3OkJccevRKEV4Wd5STtAvhculv2ZV5R50C05a57O4VFRKsc0o9x+SD2oVkC0F/nqaqfVJk2gdX5uqCZP1h7Iz1NTQ8X3Srr+dTX8S/KWY59nB4xQX5rzoRc0hN+s89X1WL9UwwM9s4xSziUowFxIfgYHnA0NhEahtW8xR75CcNtlBj7KSLV3HOGWkU8nJc/5OaQvg/91TXGAXaLu2xMYCHvCn4uq/8tl199K297iV/7X6GawAocbqC3buxIs552Ur+LWikZRrwWpXSTIfGF0MXav17z3bkabOhrJ7bNZlXj6ou5FHiQFs7c61eaUxP8R7jsUmdZpMK5GLu/TEZBDHektoY0r/+JnydglfP/ze8oVtvcRS8Sa1Owc0QrWEt/wmwFl+dN/RMzFZB470s+PLakAWmSks9xqids2VnIfqi8wBi5PIRqTtvTuZuU+495Io3Pjd2IuLX6fmjtKIAfKaGtSARMe2YPZJQLZeM+tF1oi2Qkp90IpufIkc7mOlLK2Y9rfAxD40UyG9bMdk6wzxfKN01O+x06UX+1nbfJFkMplBn5w7DWPCcyFOWahd+UXxe6GBhObG3WtxMrATrZhypJu0r3Hcz0941o2c8Xmw/kEm9zyHwmp7bgCbIs0w7LGk94Rlk3go30BMvEbRip4buEm4NrL6o5vqgEFYfruMafxcEFq3pc6Bxef6wL3f6VL1qxrneq6wLB3K
 C4e4Y8ZP
 gpOipjyAQCEvkKpPzFRiOUTTWzFkyysKhpkGWqzequIaMAP9RzzSB5scAt3f2718ze08x36mDZ7BBaEsFpjMV4ju0zC838XVYt5m3BFLZLgUx3H2T9FL/kESk/6LGgQdLHkVD9oQtqe9SGfN80iVX55UTs4P7w2XiHJjK9qLxDJdbocuvQrbgYAWn8GlvUE5rCfl+pJz0aiOE88+MPBBRfhcKMVANU3GJWHyEWNPxLihcyGadFeWs1wTs0KZnlwbEeattNN0t6SPJpYaVIKPzqcni7VZGn6tZHtSkmz/Myk/5YPDlNAK9MHIPlzGc9kqNTDYFtw2Mq2+g0FgPulUyhbVbpv7JHsGMoOnFLepwS8iWzHe4K4zz7nG3Tp8KUVci6a6IhCrwdmw4QXFULy0sD61Itm604kearHKd+9GusEatCLvA57sgkcjzzSguVILPJLc55SJSwTgS5HPWpSvuZXvCKVIrj7yH0d3bGbKr2oVzqHXXZ8onN8vgUMbdSBdz2yXtEq3QRxdPV32GoRzsYuvRgNrsKJeJZ/w5QhIuFozF5kd/Y3D7qCizkuBVV03kzd2K78piS8Kg4AM1QREhUu2m6uHjjL1afcJmwm9zk17QVflJLYHeG9/3h2bvnlFsemVW145KsccrTpA8U3vmzRNQENvBrCGSVdCv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 06:40:18 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Joshua,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on axboe/for-next]
> [also build test ERROR on linus/master v7.0-rc1]
> [cannot apply to akpm-mm/mm-everything next-20260226]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260227-033239
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
> patch link:    https://lore.kernel.org/r/20260226192936.3190275-9-joshua.hahnjy%40gmail.com
> patch subject: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
> config: powerpc64-randconfig-r072-20260227 (https://download.01.org/0day-ci/archive/20260227/202602270607.dJP65LGH-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> smatch version: v0.5.0-8994-gd50c5a4c
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270607.dJP65LGH-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602270607.dJP65LGH-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/zsmalloc.c:813:17: error: call to undeclared function 'zpdesc_objcgs'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      813 |         bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
>          |                        ^
>    1 error generated.

Hi Kernel test robot,

Thanks again, this seems like the same problem of not defining
zpdesc_objcgs outside for the !ifdef CONFIG_MEMCG case. However, in this
case I think the change that needs to be made is actually to make the
charging happen unconditionally, and within the charging functions
check if objcg is present, since the node states can be updated even
without the concept of a memcg.

Thanks again!
Joshua

