Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA07FD8FE1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEF66B017F; Thu, 26 Feb 2026 12:11:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABE96B0180; Thu, 26 Feb 2026 12:11:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083E96B0181; Thu, 26 Feb 2026 12:11:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51396B017F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:11:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C42C5859E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:11:34 +0000 (UTC)
X-FDA: 84487249308.29.E1EE527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D68B340003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:11:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3tX7V52;
	spf=pass (imf11.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJAmaqMzedaiBuo3i6ffJyCeRIKf4gcmqsYhGsTyHWI=;
	b=yqdipP64kM/tBi+Ry6fngOiTCttKW9bcjlZfRGG+BXm09HVBCCZp2A55M8Zo47JWZxBGuF
	Vi0lCz1Oc+4wMdMWb5KQ0iVAYdEL1F81GMru98EYMsutU2FTrVDkX7RRY3JS9hy8X++JwC
	cBiAuIC2h74w62UNWltWMy1onOW0/Sk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3tX7V52;
	spf=pass (imf11.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125892; a=rsa-sha256;
	cv=none;
	b=SdoCtNFsTcaR7L2VuDxrdwerTDfgKHb3bfz1fsNmkNKzTFkmP3btjdkY7uMVLgaFUHo4rq
	3HkYzIiVKjyMP5gOk1/R/zATjnrg5+f+nNgY661kPCd5ZKYfp6win9ZanR93EVa1m9grhP
	JCJH6cvsY11E5kIK4nQYxzVjf4UT2TY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F41760126;
	Thu, 26 Feb 2026 17:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ECDC116C6;
	Thu, 26 Feb 2026 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772125891;
	bh=3dAA5ZbqJT7nwllRfPjMUGsvCGPozu8oVFO1mvJ5dEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E3tX7V52KB6ZIJnP5EQdhqgy5dbKcrV70/QCeZSG5YUuzRLOU+GbRZmX6xI4LhGtP
	 wOXKgVOEGXCHkK++zmkeJMtBqtKCjhlPY9alH2plEcWMyc/+JruvQe/ULMst4wOymh
	 nDzI/JthZUc1ArkfqTnsbTii+EsbmW01L1yt93ujYlqg1GfqmC/g2KYWO31qnMDbPk
	 FxQFRrSaO/8hGA0+QF9AzNgVLnF1AwZWTfLY9FdBBu8qD4Kpl+bNqe0C8k3woJlKdL
	 I1HYF27ry7vXZCPDZXr9QkUK5PXS6FJq9mSwSkTHDtPmiekIgusGiaKcrTXd2CWShL
	 tQSNWq/Ti7sBA==
Date: Thu, 26 Feb 2026 09:10:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	David Sterba <dsterba@suse.com>,
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, fsverity@lists.linux.dev,
	linux-mm@kvack.org, netfs@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
	v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
	codalist@coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-x25@vger.kernel.org
Subject: Re: [PATCH 57/61] fscrypt: update format strings for u64 i_ino
Message-ID: <20260226171036.GB2251@sol>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-57-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-57-ccceff366db9@kernel.org>
X-Stat-Signature: hzie3rtt6mbr5uis1aj3abbrh4xxpgxe
X-Rspam-User: 
X-Rspamd-Queue-Id: D68B340003
X-Rspamd-Server: rspam08
X-HE-Tag: 1772125892-175232
X-HE-Meta: U2FsdGVkX1/VGM1fGoJ9K9Q4skJnEhKpUc5tX2mU7kb0ytayuq/Nso6Q7aF2AeYvUISJbi2WpZKj5buslzBtcrxir5eg8KjDlYNEvRZSrNpet+c6xmZsIBg+Zd/mjlNnZStBH88wpqrHzPFsdfyjrarbhOc+WZ7cumnZWwKGQoWJna3vGE+rEOuTirXuUyJ4JCoklJqBMU0OeshVz1TfKKvviwG/0XVRuuUyG7d9xXQRCOn2OCGZ3ZveTuuvC+sWFsx0ZuA/n2DByFwj0agf/kMbgIrp8T8gdYPDOR10NUs+GXCXbWtLpGxBru5fBqDmeAjxqjarQq63Iygcs0hwUFF9scqYYLvi1pejgVRX1H3CrGOlyvq6eQW3RIAFDHp806eV5zANa47qMdsFABl871kSsWNAmNRmKfxHwFCjAXVqS5kk5usahGr0xWZbof+oqxt/ZXxOfkUpf5c3Dev7ZMk/AJqkl33tS1KG0iMVpqL90dUOo1atU95Y941ItfRb/5ozLNEQ34SbwG1R3kcSETHYbzomGmiDaX99251TP/Y/TjeIO3K1eKWYCNAvgvTmUTkvLwN4qvBndlBbkPFc8IZrgmrbPKKhjONdl7U8RODZVTIkxq6V2/lvjcLH/jyNoEZmUkrOqan+QMz2YTH/iKSCUBj4kcjzjxXX/HrOOS8NftvtbolXWyq5BUEe9+9lOa0xBcp7MMizfjO8kJ/Fu7aAlUE/OJJvMpnHK+hJZjT4iAlAXw3TX6Ns0bMG8olIj5u5kmgptBE4va5kkUn8n72bSarWhGt273D9opFwKbk1zbCz35yNUj+BYdr5bx9OzcmyAT9RB40jABJsfIwRotvn7nyvZQHnDZ1YCUdRza8TZByLSYRpqlpiiepGcWX5sSLH29424YSGpWq/+OIA/AJE4NPKCjzjBon8ArnJ7924UhK5IW2f+7yGk7D4dvU+M5KHKCUTO2TH/BBY1qG
 RDqrm9gh
 JIbJNso7CymJYTTnS7BDi2sjwZRKURN2k5GJ0JKO5TSpXV8sCbM0rGQPCqUgvg6aveXJFKoWp+80HvVh/JjJfolGEuJNMsDwHX7mgiD1PayKd4JSnrI7XGnnqmYN0Vw16gGYevqYSy5M5VH5AV39p5jv//A3d1eGtHPb0HkvjUJ8sGTk/Ja1xz2kF4v9ZNGU8Q0j0lMUHvQ4yM8PNKLzP44myH6hgSLq3I+WIClfC6z0grGEKotho0eW1CKIJwDIIdG1Y1N5UQFxi/3BqKKc+eU38+OTa5Yy6+aIGK93uGBtPDWHl/0piaZUjBqVdVZDgIY4052cq38p/SsGN9atT0H6ysUT+wyHfxuz+C0oXwG7Tz+kDvSdewitcApKV33YCAwCP7MrScJrY27ddvjuV6g84PmvsXkhGmjDIvvpaGRUkTwgxuDZJYPogEdlJ2CyZPTaE8srWW5SvmSiRgZTfFIwvxi03vBs/HLpH/pzoJDeUWAw6p92/koBdgysxqAqw0SYtOzA48268tLMyG4eaN4j4u48TOJRDH69CjNBKX0Li5OWZ4w8p1p3Dkm59/LgqkrTxhEPSZiceqd4VR7P0Xc6Y/WK9q/Cadf0X3VfbALeaTDc8EIDme0r0rhZ+MZxFtJc1KqTRjWU0oyG28RS6//b1BlS3q0i1EL7HXgVi6LQL28m/BI8K3qfuXz5de5GnoYpDPZ8HyQZ+gZ9alJ8g1hz0q4pi/AMP4jyXg9u3sGyfQCCxNawEiRovvKOv/6nQDN6FO9qCfBLPutjDLk3i92GV7cqnxgAjqrImXVElSVVvZp6AnO6YIQUB/LFi819TGrbHGjIshaO4rrlNcbkSBb6ourYoTQoZ7jbDuRL5vh322vq+cYoo59wFhJ9oquATdcTYzoL/rNr1D5hB3TFs9RTO4rRiuShN1rvQFvi3htHjsHFZh0Khz683fR7pxin9+k9zPr6k0jH2GmSbWhrgWEochnzP
 HzqgDyh2
 udMFr6sMKCZ0gaBszl7DXs6RzjJ2l7Z8FecyJi+7R2cZeojpAg32hCrmjou1ByXq0bUx46IMq/s5CGFpua4NFISnDtUOcbI8YUzw2RBTFEahE+gCeA7uCWEVHgMLnNj+DamcmBXR5+S6iaV+Y1/nfOO+q+8ceyQRUCZ6hc9qOM5sTE4Td8DcQ+jJH8cCO1n+nvwEpUKjWKtIKgkj9H5BeQ0aBuSZUo1oVHbnKRf+GnxL+B3xfVqdsxqkqQjK22j/Bb7UaAH6bu8Xil5asQx0RSbb0APmbxh9DRrNdZ+jix+xo7p2hIz2Lur4nizMMFRXvByITWVfm4KwKo2hWW9qhwBbl/A1TRuANOryNocn1jNnqkAPEhVZ7VRoBdRinj6asvHtyddj2BcNsLy/j+97o6jooxLhUdgObxgjFGHD3wCJn/ZF2wLEQWkaG+sL6atHVhKwwBcWUHTtglnahaObXJPPSoWxuBy6xOhSKDXmqrnGuSgZSvCW9m18Vic2/LuOliYtSEChir487cQ1/O9GV64bQv4Pr8o9njcynb+wXditVcDXfjIgvfOPM88c4g1iZo8oNddtDxM5eyAkOVdOSeLd9IyZOygMoUcseENE3B8JgBkp0y0Yc/yOS6LO4kRBePfkq4QQqF3JYSG0ls6rp1KtLNs9vxaPehjRb+TfjwvGoCms5+k+xGjNcBCJnkLYH2E+cHIIf+IC3QBa2sh2NNxExY/LjNOBVJ2hZU2TBhkYQbwE6tNuja7JoihVzmoTiVo3T7d/IXMXS9OIYhqBhzRp7rkfeiuijZgiWkd6BzO7lmtnrwV9NTtwukvBxx0Kl2tazLg/dD1em4BzDpWTY4XIGK74K7lZ9W+KnoteKfrWPArmgVQzHFL//thCRMYaAQ5grCjHFneIRXl1gHsrA1Ft6C2U6GsBAD1ebXEJH9dwSHgy/nhRtT/mw/08oe90ZELx65Nhy6kfGquLX5dPm9yJqS5Z+
 L7OS8wLd
 JIZe0TjPBb+FLmEeTZBRqcLx5ZMgfq0pdzNojJosYVt6pFM/JfPsS4RJrj73vys2ovxjMHUWbYLHxgcfnDx0GaWNWrPBI2H89t0bwjhYQd0vAOF4HNOjTsZFL70cfwFVkB7/10NPzAaiugkDJ4N0OKAO8jTdnIll8SDbS8rrlnDYq7ABrRUvPV1TS9qrdNdR9fwJXWQEdSyptGUdQcI0/RCztrGkmCap/JGuWPNXXnsk2RXONwfDTVl17svIE+XTFISAVZ1xSHgUyyOmwxGf6/dmQ/cjT4zEIAgum/NUUOSz6RW5dKgXcdTiXvdBRPQae7pSfTQFvWzU1JlWkqdzRVezsVglw7PtEE8AuQXouEfr1OiHwM9i+3LFNFqDNpgxxc0uOVHyj8m1+OVcQkGDD4GVNPijsxGBHAiHKgPzP3ocLQztYimGBCdnPTW9gTVkDn8IMAzfyslRLcDk5dCZrFsN4OiPkcnH9/T/DelSfs5xsFIB2PXMQYugBiZydI7p5qT8boqvSddHO9hdOmhQlv3N2hsrSaNmuHUDf4hFrSqFpavPC2Z3jmGn0inbmGrYk9ApjmqR88ZUcxrv+YgrK2fppip4CAiFkCDC9UTJDXvJy49TqW15KqLVVjbZz6puZsXSeTd1WrcM3ujQxE4JIyvu5aUzXHcJm4Qb27lQXAbryyC6OyDrx+R8+N6psI6r+F+yvJgSbWi1IIk6hJFxZYp2yT2fGIoIr6IBYpeBB9FOR5Rit70SoufcKiDmuLXOFuVT99IGmRVu8vbwlovGjDQNQ/7OaEi/FzfHIF+x7TcYM6xPgSYsVPKNuK9N6f0hk+4Si+0cLbd3zrk3GRuwaLQu3RUVGBXmHgmBOFY96XlQw3Fb7wsbmCm22PVFcODJ1stgFNYAxkYktPBGLk55uQjlIfTi/+4bPCdK2eMUwzHUiDv+F9Q6fMERMm+eECFTnbvu1BK27EnLumOpIo54fFMCKpILL
 xdvpAk/D
 HHhioTbMwmQmtNeuTAKMhQ+8AR0at3KhjQQfzsg8yxNBLZnjnH+OZEdjvbPvgNltCRl0HaEX6SzjZij/ZCvNiR7o/1eqnEQ67nkjcOByouj5sqY+4OQycA0M7iIHm10g/sBm4AAiRI+Kq+5/BP2Sg0sqHrTHZCbc9Kqu85y5UQ6w+fDYl1jFdbNIJHFk0wekzsAlPCQTFmjAffG3sO40itr40LxifSD+i7n2FVCAYhfmlYKYEvQlbIq3rWouR5/rW56AvVhRa2RB4ll5oN2SyE/rFot/ZytBPiqfxSHA2XoWjIRPzuiEpNG6MtgUUeIL5lx1gBfNVaPT5E4vQMfoPFMz9yAfUqyNOs7X6T+i5JqFl8tKqfviWC5ZiFAMqOMLd8EvIbBbjotl//ivRLRZdtrve1v9qI7b/bzt417nM1Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:55:59AM -0500, Jeff Layton wrote:
> Update format strings from %lu to %llu for inode->i_ino now that
> i_ino is u64 instead of unsigned long.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/crypto/crypto.c   | 2 +-
>  fs/crypto/hooks.c    | 2 +-
>  fs/crypto/keysetup.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

check_for_busy_inodes() needs to be updated too.  It copies i_ino to a
local variable of type 'unsigned long', then prints it with %lu.

Seems that there needs to be a search for other code that copies i_ino
to a local variable, as this issue is unlikely to be unique to here.

- Eric

