Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA546C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953D86B0093; Fri, 18 Sep 2026 03:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903266B0095; Fri, 18 Sep 2026 03:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2216B0098; Fri, 18 Sep 2026 03:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 477336B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:21:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8E3F405D3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:21:26 +0000 (UTC)
X-FDA: 85226037372.22.A3697C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E9F040002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:21:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIyTlj5N;
	spf=pass (imf12.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789716085;
	b=MmWXkPaYM2nUq9zxn9OYDoK3IIrQa+eJAfh0XlPJ+XmENR4jXT3R64cGfmUfeXnkHrV3j4
	GRssh+Vz5jbuwotX80meKL06rbhcwkl1fnCA2qA38m8fX5QOlJbpEJ+Ba6T76S80Aij5Qk
	Fgiy3ukYUCHEHWvTw+MixDGPQzkHP98=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIyTlj5N;
	spf=pass (imf12.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789716085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obg8mrHZCzteuKsjo7uKdsL8y41j6SI2KsHB7Htsuzk=;
	b=IwjDBV6PyhCa38JPxuAcFx5m6N5videm0WrrRi0K1w8jN2cL18qi4g8SM7X1KuiJq5U8CV
	9lo2SK8FR9j6DxcodtB3JkpCQ3RSHqi2/IrZKbrtv7aRszaQ6pD91qCuv7lD7Qj2R0NeFr
	FRBv1OFUa5+ce71rEgFd+TtCJ1mXHgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A49F56053E;
	Fri, 18 Sep 2026 07:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEC21F000FF;
	Fri, 18 Sep 2026 07:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789716084;
	bh=obg8mrHZCzteuKsjo7uKdsL8y41j6SI2KsHB7Htsuzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NIyTlj5NJMuaPvyQ0XBnI1g4RrH1i2vsqeU5lgtPy1mcmGtvatA8gdIG2GifZnvBT
	 8Rsiih3bsJlYTSvo6buCgjlOkIXwIumRxGoV5i3swZs+YbwhwPxVw/NylyqbgWvUFm
	 2pzeZO4Ic3AtUaTeL/lJWqjQmBDOxnf6O4XctyuNRsyUUdd6ce89XQxHZAw0eHCMG1
	 vTl+7z+qj2O0FweW32GKRGefz09ejUwtNWjgeiXKAjkwHUABi28uBAC83Zp7Mivq21
	 VwNzwVrfZ5UdW+Vb+SqPxPixX/bOhscg1YZ5skM5x9iClqTW9d4n+l+ZKEIVSJdtDW
	 NwZ6DaeJ040oA==
Date: Fri, 18 Sep 2026 09:21:18 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Waiman Long <longman@redhat.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Kees Cook <kees@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Thomas Gleixner <tglx@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com, 
	netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	rcu@vger.kernel.org, virtualization@lists.linux.dev, linux-rt-devel@lists.linux.dev, 
	llvm@lists.linux.dev, Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 17/17] sysctl: assert static storage for
 DEFINE_CTL_TABLE_POLL()
Message-ID: <av3s3fgets23siaqxbtyu5gvcekqpq2nmyey6oa6o6amfj6jbi@zomsnfvvxtf4>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915031334.1194975-12-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ds2q3rrmscwpm7nx"
Content-Disposition: inline
In-Reply-To: <20260915031334.1194975-12-ynorov@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E9F040002
X-Rspam-User: 
X-Stat-Signature: ozthh7xwcksqeuudgd3erkot7t5n9erx
X-HE-Tag: 1789716084-314870
X-HE-Meta: U2FsdGVkX1/pnTeZ9O+jC5jrjB9vGnEEJIhCwPmjIslr8RJTTp6I7y6RE1svfXEpK/rIjvv/DzODxkzDd3jWcqv0Oziso5BMA1ssu+db7K+nX8bUn0sDjy/Uxs9fWJTAErP6/mbKYJ/BHkI21YDcBc81pSHdz4QJX7KsnRL/OQoX5CDBMhQt1zWv8qlGhy6yMdvbD9EkQ7O6bFWOB73H+yjBnqsrpR3Ql+he0S8VPtZOfvJ7mO4p8sNowlcsgWRr+gX2Npfl8JusoZTUdRGQifEjUja6klRN67hC/GjnEFzLLGfHQnZH86p9359ku+g71Pu6CpAx/ILNVbbxZDYiqLV9B+tKJotuXkLl1cKXe+Y6VuKxRecCE1/+xcfODsPCucuJppLPCas1NVTeaaQQ0Wclu4Aw8+7c8hqAUNDKkDJyiartxkjys94nBHJz9HrCbyAmjoMDkaWTuvnCqv81i6k5F4iPJ75h2rxGj49xVX13CDe6I/uHZ4WzmVTsFwvvad7vgv8yuuCZbpUtrtAupSsymL64zm2kPzshL0pu5yqQtGU5tMNY14dgpeUHyXij1TA+iZCikPfukT+Ood36h4vKAmYfS1NHZiR9N1JSaeyEdPpSreF6OLRDlOPPAcDjaH+1crbgqQ3PUFPruOpJhZbctuFrb/5fpXduIQ5+66pbyq8EFVPzN/pMC59HoN94RTrccSAZFoItQt7/ZbbIaASQDUnEFVzsFUmkSvqCgw0GIELFR6C20578pFZKBnteJK6MgaAGvc/mQThusbsZP68RW3+veUD2wKtLsNOItGMJOi9VzcT9GoCnka/G1xNxz/hZ0eccaLFRdkE60oWgN5QUion0u3LqGD+fBMFPN+4DG1IENWI0sxWp290bWIxzOxBWo3mXExiO/pXzMJ6P6sWW2h4E7+WcXk6QI+ZxH0Pc+/f7K3Su/GUXCM8hxoBKUy6WzSH+UkuOYVnYOH8
 Fc1XVwy6
 QetvxJNe6rwgcoD16lBjkHVib2bkDOV5tKGmQrzk6mzKW9uO9CzHvTvEeXOrxuZO9zaW4+9o+mIXTXNJNSsZzge9AFRwjMXMfUYMPFZBVlXRNHCvboIJfDhOFOCzmy6iSTFP6AcGFsr8fGTXKQOWK5+mCtfLRo7I3EQw86yyCD5is6s8WwL0wijZDyboaqX31TYzOL2/KwnawzGJfdZ/FJ6nl69m8Hnv5aZBZNMtUNK31jLYm5ChqEcWqnd6EQ5gj3Gbuu3OUaND5DZUi2eRfmGPD9u1zXOO1VlrS7F74Z9E1a0PlwQqWQ8VIN+RAm25vjslYnjbTw3zwCyVsthYIRApJz4bKg5izuNo3hbkmjAzgX0T/OfWlhsCAIWgTmazTs4/CGAJcy9nQ8hsFFwhwfZeTW+ek5+ChjluMo2x+BDbp3k0ZWf79UIUGxAs0ICiBqMO5WspeQ0D8BRuBd6iVb+6V5EKu7R/IFIMecOGCf/YOcy9bCiS0hebSCm3slm4+CvMLoT66WShSfIN225L8e7fQM05JoNCrLiQsSAOH4XuBzPjofE1dEIblIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ds2q3rrmscwpm7nx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 11:13:32PM -0400, Yury Norov wrote:
> DEFINE_CTL_TABLE_POLL() statically initializes an embedded wait queue.
> An automatic local poll object cannot provide the persistent lockdep
> class key expected by its wait queue lock.
>=20
> Add ASSERT_STATIC_STORAGE() to reject automatic declarations while
> preserving file-scope and static local definitions. Leave the underlying
> initializer available for embedded objects.
>=20
> Assisted-by: OpenAI Codex
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  include/linux/sysctl.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index e5d7226ab6f5..be79359346af 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -22,6 +22,7 @@
>  #ifndef _LINUX_SYSCTL_H
>  #define _LINUX_SYSCTL_H
> =20
> +#include <linux/compiler.h>
>  #include <linux/list.h>
>  #include <linux/rcupdate.h>
>  #include <linux/wait.h>
> @@ -216,7 +217,8 @@ static inline void *proc_sys_poll_event(struct ctl_ta=
ble_poll *poll)
>  	.wait =3D __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
> =20
>  #define DEFINE_CTL_TABLE_POLL(name)					\
> -	struct ctl_table_poll name =3D __CTL_TABLE_POLL_INITIALIZER(name)
> +	struct ctl_table_poll name =3D __CTL_TABLE_POLL_INITIALIZER(name);	\
> +	ASSERT_STATIC_STORAGE(name)
> =20
>  /* A sysctl table is an array of struct ctl_table: */
>  struct ctl_table {
> --=20
> 2.53.0
>=20

This looks OK for sysctl and the two users of DEFINE_CTL_TABLE_POLL in
utsname_sysctl.c (hostname_poll and domainname_poll)

Reviewed-by: Joel Granados <joel.granados@kernel.org>

Best

--ds2q3rrmscwpm7nx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqs5mgACgkQupfNUreW
QU+Slwv/V1va9Xy3ewVVGpZbKof7lX0SuxpAV+wYGoQU9hE6Ofexe2lgpstvBg5q
R4BplT9ThJvF8d3hzCkPNWmWHuXW19VfnmKKdy7zNHYo8lyVLEyFmOlw+3sZ6czr
e7JVfspT2rWbf/0oF8GiQvMCV31pFqQty+c4bb5ZV64xBCKqIxBX9DMXYOstdt1z
hRlSyBTjYabun1LJPo7Nkj/puYlCklMcipRzJNONXZgWt0LFRsCYSZRrAdk2ISeP
y7e87NG2DiVBd/d58WvPvdwdpmhX4vHSNXdSbeLwTn26F3bg7yaNsXd2sCSVTu/o
4S0G/bMFUP/e2oNe/wtaO+XBnDhJYPk3DGvYkFf/C8DFyCVi36tjb4SrQv3D0QV9
PGWE2Hek8KHr3W4oRbZIQm6zMUwg9/fu4speRR5+1xnuBlVsRXtEOQgEr/DkWYHw
8SYHe3rOXtaFsbMWdItXR1CRib516haep77aGjErq93c3ViZF1JEEMBQdXjqjWmm
LKs/7uqR
=5LAv
-----END PGP SIGNATURE-----

--ds2q3rrmscwpm7nx--

