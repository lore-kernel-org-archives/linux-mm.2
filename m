Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0051BEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698206B00C7; Mon,  2 Mar 2026 15:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675C16B00C8; Mon,  2 Mar 2026 15:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531BA6B00C9; Mon,  2 Mar 2026 15:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 404E76B00C7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:32:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8608585A4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:00 +0000 (UTC)
X-FDA: 84502269600.17.8E4AE1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F6F4140008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:31:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Li6sL0a+;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772483519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPORq74oJJgveaD71R0CbdKwbGychA5m9ZqVCvQco5o=;
	b=FAeuWAButkazbv1wJMM7csaAjMpPorr0Vp28Z/QJUOFwK6A57oxtShLYIQedZyR/hqCNyp
	ATu7i6NXWo7HNdYP5T94igehfMeHrbx179lgK3py8VM7zl/okCJsDghVXuenSUYoH46wM1
	oS1hWgYT3Dy1U401cmyuFOV0Zt8GkhM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Li6sL0a+;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772483519; a=rsa-sha256;
	cv=none;
	b=q/x1jPtQJL19wZcMUzDqgjxJmL8F6IteK4dCUxgIIWu0K6GOh4oj9A4buWdFYOTgDXlf6j
	OLTJEosO6ZWM9joDm4SHbOFIH9BMQ9gwYT6+QGf/voroKoqNgX/+toQX+q3WD9GwDgU9cJ
	8BbmvERnLhKotLcAs4pSmkFJ01eKdbI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3996660180;
	Mon,  2 Mar 2026 20:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEF4C19423;
	Mon,  2 Mar 2026 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772483517;
	bh=XoVTzN6eBFxJLa+BE/pk+HgcXW2U/zY8piTlCXX74Rc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Li6sL0a+oyYaZb5loMXRQVVEBqU5MM+GmRSYreCrPJmP26o1SIPa0bN8EuAYhSZYk
	 OBNRTSv6Dv1enDzk4AG3b7TJmehy8EMyM1JloGvvoov1tJBTbMNPMlQoeXgjWDiE1K
	 qqRX/Nr/WHSlT2DFVPAMNRywBNda1P9ICWR7mV/0eAEkOqQjOKufgWQ5XS4uj0JS3/
	 58xxHS1csLhK6vkvYAxdIwyo5hfFIQblKazZHdPySc0O8GZ8ZAluKPBWA5oTReccst
	 LujABIFDexfk7Iq1ESPn7xqWw3YoUVFXLb0R3MC2wPClKxcaSnCpEl/EjO7SGs7LXb
	 tsDDMqy6zc3zA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Mar 2026 15:24:13 -0500
Subject: [PATCH v2 029/110] ext2: use PRIino format for i_ino
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-iino-u64-v2-29-e5388800dae0@kernel.org>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
In-Reply-To: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Matthew Wilcox <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, 
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
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>, 
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Yangtao Li <frank.li@vivo.com>, 
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>, 
 Zhihao Cheng <chengzhihao1@huawei.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
 Willem de Bruijn <willemb@google.com>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>, 
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>, 
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, 
 Johan Hedberg <johan.hedberg@gmail.com>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Oliver Hartkopp <socketcan@hartkopp.net>, 
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Remi Denis-Courmont <courmisch@gmail.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Magnus Karlsson <magnus.karlsson@intel.com>, 
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org, 
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, 
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
 linux-x25@vger.kernel.org, audit@vger.kernel.org, 
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7599; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=XoVTzN6eBFxJLa+BE/pk+HgcXW2U/zY8piTlCXX74Rc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBppfH2w5Kjq4Q8NCePjxszp9Wu5rq+HJV6Zr+aA
 xQGuM4HB8KJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaaXx9gAKCRAADmhBGVaC
 FaQdD/9NXJ014MXWsM0uAaawc1kzXHnQlnBEkq2ZeON6ZwhV7CSSGDYwroD6I+qfapTTiD3jXcd
 Vv91VggjPIwqKecXFfuVetJ5B1jcGosi9aCSzi4raBk/H1Me+mWSGXfzu/UbDcq4Voib3Ie0xDy
 9q8iKw5ESYgO7fN8ym9mxGXlQ/QmsVyEaow+0HgrI5x+csk5o5CUD3j7Bv9XjJ/kbROoLj/O4io
 lUXibWs++d0XTW/ZFelDxtjGSs7AW97lN4d0OVRa3BYuqW53vpW1xK1fhNQHQb60pKle6r0pIFA
 EJTTPtguR6pb0ZiKMlC5co9czELzU7uoX5qqbh3lAYNbKwQ4tm2rJxf1wx1SyTJBN95fbkXR9QU
 GA9zL/OdsrM6s7XTqWbFrzaouw4mTyjroSyF87iEHX8CinFBxMlMJbtQGCExULWYNAJLcW4LAac
 QBx8NvfE/3VxJzIVjvKSynV6xJm/0jf7BRoCQSLGCjgC2M9Y92WDxIlNJe1I3NDiK6oCVwY8N/P
 RAai1/XqSyTwjz4HvSzW7yC4kF4IoYiQMEkKxDg118CeFfl2nYUaNynVWJt7+CutXoSOA4QFUi6
 fsqvliM7tl7pbZniEYsaTfx1PtOVhrNEORSL8mgP8TBeHplfYrtwfRF5I2WIHWQQhCiEk3iOxDP
 9IMmkuJ5S8qUbJw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F6F4140008
X-Stat-Signature: ydc3monxpf51kb817z6kwch44ibyzohb
X-Rspam-User: 
X-HE-Tag: 1772483519-669711
X-HE-Meta: U2FsdGVkX18EJpH0FOprFpfQkNL4sYx+D/wQXIhELuaQ5mUvnIqC7+PllIdMoR2erR46drtyR8/KV6GW7yqQWDyBZNP5652cN8FZFGUSKZdjhIMkFS+FgY0DGc1P+4XkzDZ6JebJfyYgUPv4T1zDsuUlHQpBloVKoFVJg/HFMrAOpitWaPeqkSP1s+0vWXqq5wg+Qb9kgueMtQafz0dNqhuzCIv0h6j8ktiLVD3ncBjJsKwk/MR8n7147OZXodfw9zuJo69iTsukSFjwUogCSU1WAp44af31O7HYcMzcGHVJblnFVl4b1TednGBQGHZHo3Fr9MytEsZyhSvT52W1mE6N0HoDOI0jRzDX2t6SHZbonUeIrHqhgQ0PzZAJu74MIPIZdSUxBt8pPcS+Z/Me2Tsp0AfPHFmzrDI6P/PH5lOhgoxrJIlv/dfFGo5UCnwCjAs/u6p52ypsORywJEwBNSW0XjFX/HZ5u9WhoR2rIrUtXyfaCj0G7iV1Gcp3bjKhF7iybYu66nxHfbEKty8jHfN/KNK+V8TOW1E1XfjKtI86me50YQmwXQfwHKQYrLUZw5QiodZHWlIOu9FVG3yqgFdHtqLj4Den+Q5jDP3YcpDBIMM7HzpiOqPcKemyIiFd+5yTpEACdEWeHwABZRTl/7XcMKQV9v3djHMOXg7+ph7CAbOhuyJDA/AHcERo5Q2OynIcvh1a3ms86mGHj6F+T9gHOtDvgvzaLQHPiS3o4m3druyhCfjqlRuYT/3GoJ9jBc3pPD9/FokR52Y0hhgVJW8Yq4lvyOvpNm0BHknmkPDZ/apzDv3WPo4laZ1PawasZfkzl6J/NX6kFvBErZhZBnwkEfxDC86u4iuLxFVPVtrnjugJPEbC40MaGagPqI7hZmikcZdC419hduo50WxHV1iw6/2J9zTtFp+XrvJ3CAAFlSZmM2Wbd3ed2qNBYcq+wDHtUFxTdYLPUShALFC
 Vrz45jeA
 Lu8xzbAYtD1sRi7XlhfWxYkdaWlp3JWp/Bx4CjmSVJU+juO+A2MglKJPwwwxaa4m+j1fgE80jUfac3fXrsu7M4zsCMFytpmgX+H5INXpp2ps4zKWzTM8HRIRJ0mSWbgQ+bwxqLJYWENRZtWF+yJX5VV24t7Sq5vyB5rN2KZjScM/133ZvxZ3eIIl+GhUtAaxJs03oUiHS/+Za4pqWEDBISGMDDF0SxN1g2BPi4eylLIMrFjWI5/u4sTM3ykCdtaGyS9hqRO9NtPbuc/DviEBoTb986JDK+mre2HquqRxpNDgMTbBxmc2/veAckKYJ4PBYvbqy7fRtbGHe0qN9THU5Etc6b6YwRppkhXg0WtTAYIK2Xl33ROLb+R33ZtyXHAspT2cK0dQfAyAXzXLmYBJpXvE+gWxRh4KtkSE1o5hfWLTNru0edYsAaFL9m+KtEu89t5CHL10r3sVOuTMk7CUdkfHolLgzme6Yy6zbJno8ToLdZ5KlFIA/0eowG4WEU4cpPN5XMNTnvVbf+dBKJkaz61zgs9/Dmm5OvVxapKwMi0XjPCibt8cFl2260JK1nF8hd1bBxupSbTZqAk244BKaoW3DMltyZcow2bthEg2IUfD0YDo6Tb2GVMXrfLur37mWzBP2UXVYZVIukyXVgU0Fh/WC+6vEBMEFxFFrwWjbWIVV5uXtyVNkotISoQ1H/e7Lri9EMENkxSCtuN81DfZN+tjGskSOuTLr38WHwjuT1wuDnkpDc/k/x6KUpTrWt17XRRDbQf2Ue8QBYQUhrDD0rRG5XI3JIYaRsPNG9WdcLodME7W79hmOOEb/JjVy8iJw+O66ySDP8YThQxCah6ytAxZYMUFiUrJNkqKkg/B2N/wH0Zc7c3HdvPaW4gop2o3T9qhxh/4wwuhgv+Rqj+0HW8o5LF10HNmLv4S9/AxBTqiIIAny/SN502jeyz+jjq3kZv88mVCkd+5DOtINYHMzJ+OFYG+1
 orpmAJCy
 8fVFjsmYVOlzeuAnMYwY6QXblPCZ3cuZMDPBrtYd3fkYpRYYIs4HvrD3TJqw78yE19TakXdRj/yixZy+tdPNqVtKvwgbuwVxPR7vuKOYioh7x4oLUhb11RGQjFDWVkDt7ZuRC7/Z/X8pnEL8zs7sg9oJ8IRnn2hV5P+FBYcWJJ0G5aorWbbYmuJS/sArp33qxZ3/OJxvXkhguDm1iYYxRw6a2VZrssYsfojKeuSK10BIDwj1D6onWGIhvStewC7YiGV3UVQj8LtP94lN+QZrhCUnNWGm89j3XioeuQGLMycLR6jzycax0v1Nv3+nq6wD7oqth9Uas/ScfTMzaHAjgulSaDXDv59JWbJY2/LHlhowLqkWzaWUKA/WG5JfCkMeJFMgAhWrPdYru3nFv3+EUz/IC1RMn3SAjYA38dnwWJpqsZ6HpxoVk7gG9uFZu8peQAacwC3/FpWJ9EySU0aQMAWNjrqkx+KUVmkRLvl6q7KASS7F4OydYAx33maCZaqUFPK1mXUInKx5OXZDX2u0TswVHv1mK9JjLJo90/N8FdAm+kyx+PpvAEooBHWTjuVIJUHdW9i/F6b2BXmo6jgaPT3h4tH3uDNfIfXtbhhKNh+PawsZuuwXeD8KIFHHmx9V/CpAYtH932Mtg/wOSlQtXjOtPR7qfIc2IdG2Cazqr6NwC8MudnIWobryqI3q6pE5Z9uStKXTBD4w8Mt2BY4Bk0tdtU71ZKOTKS4DHwH0OSflo8r6oeUpc6/9Gi8yPTf5RVxf+lMgI75U/bQZFUQfN8S47qpTSCAJzQqX1YnGCEhfdlhsBGk4XQtexirOhp7QNC6xpzejXStdLynlB3ax5eCSyIHgzQBimVtiqz7sDHccj2mLxKQ6Gq0Eyfmdj4IvAqd8cZ0U8og3zUtT9fSsE/juy3icL7O83qjlnZggkWkaAuK3KxFshYMPJ0LWfASNQPIWzk20HzijTt6Cugvi3wIQJzV41
 h6gUcDGN
 ID5gik9BCJOe16LHgwnb3hY/1IWeJHJFlRGvphiVCb0/WWKI1uUD8igSx88KnVOje3vUwZf9RcOsyOolWrKg+pYGIj5f1e93cXBrKkVdqUfwBOD5UinnZmRztqRIHlkrN+6ZxYqzBwpeMsv1mIiCX0VClVMBBukJUKLhA/zgiRFJJ51tDjB/VZ3UIPytqNnSq60wU9dJhpZxpj1uKIvxJYGiQBAlE7Tkgfzo7lf7fwkWz4KVN5lKlts2RZKhfrUHyWqdfPphrrdc4q+9fqDvD2MkyMsCFAehPMwoi0KUKVZxN7drqnmNXTx+ltsNgPjQUJok+WUpDXrMUhckxJLh1YMpLtKAHqEkdRn+fvvxTVor/EY/UFmRqC5WiPeus/1FM0jpGBgPBTbcU4s+aATV5lMzEeqNJ98E4RrY5VpKY1pj0t3QuTodq7EbdXnh60xVuWF1W3LCQSfO3yqjXGesst35TZQ5Yky8PIC/P7/uiAzsA3AiKXd6b545g2juFmCn/CUsLS33Gz4t0mApgoVsZKHEeyiwvemT0Y2XPT0uyXvCBNz+mWkDz1nVtlyN10XrPMDJfvWkYJ6Liu4v/SHO0GIezftTz0INZWnT+fNR2//jlnHr/qnXFK1yj/j8sNHjx5dDBMacAdkM5wN36kSVY+ivNtKRIlt02dHoeh3w/wcNlztcb4c9cF2KkXHtvIRn0vkuUD8sH8I4RfbvG6BSo8jGcMloWTEHu3Kx/Q16BN1fvGxNB8AHR755zWqM9qOMdciLTBQwVDOGuX/RQiNCplGW9nIRraGXydHlXvnyI440tgOt4QzHoYDkv72wgxOMzmZTJFMxpZb0HeRi/jYvkJX9wsZB+Uyd7NzOmQrLH8MLo/+XqowS4MFiaY0zryWjab3NsA1oBACxuZA7fdPhbc/gTB3De39aM+az7PdjEAxqmq1XLPckV0jJfARWlhcOA47VUHZjrKj0+lj/bLaYIcS+iEbFA
 z8i0QNrW
 okeQ3RMiaGx/7mmj3lWHT3Zfg5W4o7CSdmd1qEwvq22b6jMv2pwBVMHnrGjui5UcNB9kHIJttNFYALqt40FO6vAZdpmJBpaBUGRG3xqpAZxQTJDQg7w88YVOauiEd+GOdFJIQe9qrIZ2BN3+2fSQnGd4EDdO28PT3FJxaSaYpLikbCU/CfJBHtS6tIBcA7YKngX2pUKzYDOi/4GFimJGL0+2gTBlOtsPmGfl7iCV+Voyw+/Y+94ho9xIfGQgXhahqBP3aSaRg3PPqCLFj7r1ocdL2YWdMMkFQF3kYtmD9ocMNr3ggLLO0/cu2gnWoItoTEKIq4mKwkGLk0qwyYMzQW2AK8xW8xIb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ext2 i_ino format strings to use the PRIino format
macro in preparation for the widening of i_ino via kino_t.

Also correct signed format specifiers to unsigned, since inode
numbers are unsigned values.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/dir.c    | 10 +++++-----
 fs/ext2/ialloc.c |  9 +++++----
 fs/ext2/inode.c  |  2 +-
 fs/ext2/xattr.c  | 14 +++++++-------
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 395fc36c089b7bb6360a8326727bd5606c7e2476..f87106907da31bb7c1ca65c0ec2dcc0d47d27c62 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -141,7 +141,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 Ebadsize:
 	if (!quiet)
 		ext2_error(sb, __func__,
-			"size of directory #%lu is not a multiple "
+			"size of directory #%" PRIino "u is not a multiple "
 			"of chunk size", dir->i_ino);
 	goto fail;
 Eshort:
@@ -160,7 +160,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	error = "inode out of bounds";
 bad_entry:
 	if (!quiet)
-		ext2_error(sb, __func__, "bad entry in directory #%lu: : %s - "
+		ext2_error(sb, __func__, "bad entry in directory #%" PRIino "u: : %s - "
 			"offset=%llu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode),
@@ -170,7 +170,7 @@ static bool ext2_check_folio(struct folio *folio, int quiet, char *kaddr)
 	if (!quiet) {
 		p = (ext2_dirent *)(kaddr + offs);
 		ext2_error(sb, "ext2_check_folio",
-			"entry in directory #%lu spans the page boundary"
+			"entry in directory #%" PRIino "u spans the page boundary"
 			"offset=%llu, inode=%lu",
 			dir->i_ino, folio_pos(folio) + offs,
 			(unsigned long) le32_to_cpu(p->inode));
@@ -281,7 +281,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 
 		if (IS_ERR(kaddr)) {
 			ext2_error(sb, __func__,
-				   "bad page in #%lu",
+				   "bad page in #%" PRIino "u",
 				   inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return PTR_ERR(kaddr);
@@ -383,7 +383,7 @@ struct ext2_dir_entry_2 *ext2_find_entry (struct inode *dir,
 		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			ext2_error(dir->i_sb, __func__,
-				"dir %lu size %lld exceeds block count %llu",
+				"dir %" PRIino "u size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
 				(unsigned long long)dir->i_blocks);
 			goto out;
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index fdf63e9c6e7caa6d5267c25faa6c293622f00627..6a317411e54191578343308b5a3990aea9c36436 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -169,9 +169,10 @@ static void ext2_preread_inode(struct inode *inode)
 	unsigned long block_group;
 	unsigned long offset;
 	unsigned long block;
+	unsigned int ino = inode->i_ino;
 	struct ext2_group_desc * gdp;
 
-	block_group = (inode->i_ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
+	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
 	gdp = ext2_get_group_desc(inode->i_sb, block_group, NULL);
 	if (gdp == NULL)
 		return;
@@ -179,7 +180,7 @@ static void ext2_preread_inode(struct inode *inode)
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	offset = ((inode->i_ino - 1) % EXT2_INODES_PER_GROUP(inode->i_sb)) *
+	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(inode->i_sb)) *
 				EXT2_INODE_SIZE(inode->i_sb);
 	block = le32_to_cpu(gdp->bg_inode_table) +
 				(offset >> EXT2_BLOCK_SIZE_BITS(inode->i_sb));
@@ -381,7 +382,7 @@ static int find_group_other(struct super_block *sb, struct inode *parent)
 	 *
 	 * So add our directory's i_ino into the starting point for the hash.
 	 */
-	group = (group + parent->i_ino) % ngroups;
+	group = (group + (unsigned int)parent->i_ino) % ngroups;
 
 	/*
 	 * Use a quadratic hash to find a group with a free inode and some
@@ -589,7 +590,7 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
 		goto fail_free_drop;
 
 	mark_inode_dirty(inode);
-	ext2_debug("allocating inode %lu\n", inode->i_ino);
+	ext2_debug("allocating inode %" PRIino "u\n", inode->i_ino);
 	ext2_preread_inode(inode);
 	return inode;
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a1245d97ba97cff24395754197043c33..0ca9148583646812b478f01fd35bcad11498f951 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1152,7 +1152,7 @@ static void ext2_free_branches(struct inode *inode, __le32 *p, __le32 *q, int de
 			 */ 
 			if (!bh) {
 				ext2_error(inode->i_sb, "ext2_free_branches",
-					"Read failure, inode=%ld, block=%ld",
+					"Read failure, inode=%" PRIino "u, block=%ld",
 					inode->i_ino, nr);
 				continue;
 			}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index c885dcc3bd0d180c4c3f0945ca23ed8ce569ef10..4b3dadc0a2a47c85682d9c74edb900cf0f20996f 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -227,7 +227,7 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_get",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %" PRIino "u: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -313,7 +313,7 @@ ext2_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 bad_block:
 		ext2_error(inode->i_sb, "ext2_xattr_list",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %" PRIino "u: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		error = -EIO;
 		goto cleanup;
@@ -454,7 +454,7 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (!ext2_xattr_header_valid(header)) {
 bad_block:
 			ext2_error(sb, "ext2_xattr_set",
-				"inode %ld: bad block %d", inode->i_ino, 
+				"inode %" PRIino "u: bad block %d", inode->i_ino,
 				   EXT2_I(inode)->i_file_acl);
 			error = -EIO;
 			goto cleanup;
@@ -833,7 +833,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 
 	if (!ext2_data_block_valid(sbi, EXT2_I(inode)->i_file_acl, 1)) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: xattr block %d is out of data blocks range",
+			"inode %" PRIino "u: xattr block %d is out of data blocks range",
 			inode->i_ino, EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -841,14 +841,14 @@ ext2_xattr_delete_inode(struct inode *inode)
 	bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
 	if (!bh) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: block %d read error", inode->i_ino,
+			"inode %" PRIino "u: block %d read error", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
 	ea_bdebug(bh, "b_count=%d", atomic_read(&(bh->b_count)));
 	if (!ext2_xattr_header_valid(HDR(bh))) {
 		ext2_error(inode->i_sb, "ext2_xattr_delete_inode",
-			"inode %ld: bad block %d", inode->i_ino,
+			"inode %" PRIino "u: bad block %d", inode->i_ino,
 			EXT2_I(inode)->i_file_acl);
 		goto cleanup;
 	}
@@ -952,7 +952,7 @@ ext2_xattr_cache_find(struct inode *inode, struct ext2_xattr_header *header)
 		bh = sb_bread(inode->i_sb, ce->e_value);
 		if (!bh) {
 			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
-				"inode %ld: block %ld read error",
+				"inode %" PRIino "u: block %ld read error",
 				inode->i_ino, (unsigned long) ce->e_value);
 		} else {
 			lock_buffer(bh);

-- 
2.53.0


